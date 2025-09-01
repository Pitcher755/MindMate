
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SoundsService {
  final _db = FirebaseFirestore.instance;
  final _cacheManager = DefaultCacheManager();

  // Dos reproductores internos
  final AudioPlayer _exercisePlayer = AudioPlayer(); // Para técnicas, ejercicios, retos, etc.
  final AudioPlayer _globalPlayer = AudioPlayer(); // Reproductor global

  // Lista de reproducción global
  List<Map<String, dynamic>> _globalPlaylist = [];
  int _currentGlobalIndex = 0;

  // Favoritos globales
  List<Map<String, dynamic>> favoriteSounds = [];
  

  // Estado del reproductor global
  bool _isGlobalPlaying = false;
  bool _pausedForExercise = false;

  SoundsService() {
    // Cuando un sonido global termina, pasa al siguiente automáticamente
    _globalPlayer.onPlayerComplete.listen((_) async {
      await playNextGlobal();
    });
  }

  // Obtiene un sonido random de Firestore
  Future<Map<String, dynamic>?> getRandomSound() async {
    final snapshot = await _db.collection('sounds').get();
    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs[Random().nextInt(snapshot.docs.length)];
    return {"id": doc.id, ...doc.data()};
  }

  // Reproduce un sonido desde URL usando caché
  Future<void> _playFile(AudioPlayer player, String url) async {
    try {
      final File file = await _cacheManager.getSingleFile(url);
      await player.play(DeviceFileSource(file.path));
    } catch (e) {
      print("Error al reproducir el sonido: $e");
    }
  }

  // Reproduce un sonido de ejercicio/técnica durante [duration] con fade out
  Future<void> playExerciseSound(String url, int duration) async {
    // Pausar global si estaba sonando
    if (_isGlobalPlaying) {
      await _globalPlayer.pause();
      _pausedForExercise = true;
    }

    await _playFile(_exercisePlayer, url);

    // Fade out al finalizar
    Future.delayed(Duration(seconds: duration), () async {
      for (double vol = 1.0; vol >= 0; vol -= 0.2) {
        await _exercisePlayer.setVolume(vol);
        await Future.delayed(const Duration(seconds: 5));
      }
      await _exercisePlayer.stop();

      // Reanudar global si estaba sonando
      if (_pausedForExercise) {
        await _globalPlayer.resume();
        _pausedForExercise = false;
      }
    });
  }

  // Detiene el sonido de ejercicio
  Future<void> stopExerciseSound() async {
    await _exercisePlayer.stop();
    if (_pausedForExercise) {
      await _globalPlayer.resume();
      _pausedForExercise = false;
    }
  }

  // Reproduce la lista global (desde index 0 si no hay nada)
  Future<void> playGlobal({List<Map<String, dynamic>>? playlist, int startIndex = 0}) async {
    if (playlist != null) _globalPlaylist = playlist;
    if (_globalPlaylist.isEmpty) return;

    _currentGlobalIndex = startIndex.clamp(0, _globalPlaylist.length -1);
    _isGlobalPlaying = true;

    final url = _globalPlaylist[_currentGlobalIndex]['url'];
    await _playFile(_globalPlayer, url);
  }

  // Pausa global
  Future<void> toggleGlobal() async {
    if (_isGlobalPlaying) {
      await _globalPlayer.pause();
      _isGlobalPlaying = false;
    } else {
      await _globalPlayer.resume();
      _isGlobalPlaying = true;
    }
  }

  // Detener global
  Future<void> stopGlobal() async {
    await _globalPlayer.stop();
    _isGlobalPlaying = false;
  }

  // Reproducir siguiente sonido global
  Future<void> playNextGlobal() async {
    if (_globalPlaylist.isEmpty) return;
    _currentGlobalIndex = (_currentGlobalIndex + 1) % _globalPlaylist.length;
    final url = _globalPlaylist[_currentGlobalIndex]['url'];
    await _playFile(_globalPlayer, url);
  }

  // Reproducir sonido anterior global
  Future<void> playPreviousGlobal() async {
    if (_globalPlaylist.isEmpty) return;
    _currentGlobalIndex =
      (_currentGlobalIndex - 1 + _globalPlaylist.length) % _globalPlaylist.length;
    final url = _globalPlaylist[_currentGlobalIndex]['url'];
    await _playFile(_globalPlayer, url);
  }

  // Cambiar volumen
  Future<void> setVolume(double volume, {bool global = true}) async {
    if (global) {
      await _globalPlayer.setVolume(volume.clamp(0.0, 1.0));
    } else {
      await _exercisePlayer.setVolume(volume.clamp(0.0, 1.0));
    }
  }

  // Agregar a favoritos
  void addToFavorites(Map<String, dynamic> sound) {
    if (!favoriteSounds.any((s) => s['id'] == sound['id'])) {
      favoriteSounds.add(sound);
    }
  }

  // Quiter de favoritos
  void removeFromFavorites(String soundId) {
    favoriteSounds.removeWhere((s) => s['id'] == soundId);
  }

  // Limpiar caché (En principio la función estará desactivada en principio)
  // Future<void> clearCache() async {
  //   await _cacheManager.emptyCache();
  // }
}