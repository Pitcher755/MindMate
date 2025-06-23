import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/features/auth/services/auth_service.dart';
import 'package:mindmate/models/user_model.dart';

/* Proveedor de la instancia de AuthService 
 * (para inyectarlo donde lo necesitemos) */
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Estado para el usuario actual
final authUserProvider = StateProvider<User?>(
  (ref) => FirebaseAuth.instance.currentUser,
);

// Controlador de autenticación principal
final authControllerProvider = NotifierProvider<AuthController, User?>(() {
  return AuthController();
});

// Clase encargada de controlar la lógica de autenticación
class AuthController extends Notifier<User?> {
  AuthService get _authService => ref.read(authServiceProvider);

  // Estado inicial (null significa no autenticado)
  @override
  User? build() {
    return FirebaseAuth.instance.currentUser;
  }

  // Registro de usuario con email y contraseña
  Future<User?> registerUser({
    required String email,
    required String password,
    required BuildContext context, // Para navegación
    VoidCallback? onSuccess,
  }) async {
    final user = await _authService.registerWithEmail(email, password);
    if (user != null) {
      state = user; // Actualizamos el estado directamente
    }
    return user;
  }

  // Login con email y contraseña
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    final user = await _authService.signInWithEmail(email, password);
    if (user != null) {
      state = user; // Actualizamos el estado
    }
    return user;
  }

  // Login con Google
  Future<User?> signInWithGoogle({
    BuildContext? context, // Para mostrar errores
    VoidCallback? onSuccess, // Callback para navegación
  }) async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        state = user; // Acatualizamos el estado

        // Ejecutar callback después de actualizar el estado
        if (onSuccess != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onSuccess();
          });
        }
      }
      return user;
    } catch (e) {
      // Mostrar error si tnemos contexto
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en login con Google: ${e.toString()}')),
        );
      }
      rethrow;
    }
  }

  // Subir imagen de perfil y devolver la URL
  Future<String?> uploadProfileImage(String uid, File imageFile) {
    return _authService.uploadProfileImage(uid, imageFile);
  }

  // Guardar el documento del usuario en Firestore
  Future<void> createUserInFirestore(UserModel user) {
    return _authService.createUserDocument(user);
  }

  // Logout
  Future<void> signOut() async {
    await _authService.signOut();
    state = null; // Estado a null cuando cierra sesión
  }

  // UID del usuario actual
  String? get currentUID => _authService.getCurrentUid();

  // Guardado en memoria de datos de perfil temporales antes de pasar a Firestore
  String? _name;
  File? _profileImageFile;
  List<String> _goals = [];
  String? _mood;

  void updatePartialUserData({
    String? name,
    File? profileImageFile,
    List<String>? goals,
    String? mood,
  }) {
    if (name != null) _name = name;
    if (profileImageFile != null) _profileImageFile = profileImageFile;
    if (goals != null) _goals = goals;
    if (mood != null) _mood = mood;
  }

  
}
