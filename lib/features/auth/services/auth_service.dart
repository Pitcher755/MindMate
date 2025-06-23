import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindmate/core/constants.dart';
import 'package:mindmate/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Registro con email y contraseña
  Future<User?> registerWithEmail(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    // Enviar email de verificación
    if (user != null) {
      await user.sendEmailVerification();
    }
    return user;
  }

  // Login con email y contraseña
  Future<User?> signInWithEmail(String email, String password) async {
    final UserCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserCredential.user;
  }

  // Login con Google
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    return userCredential.user;
  }

  // Subir imagen a Firestore Storage y obtener URL
  Future<String?> uploadProfileImage(String uid, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images/$uid.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error al subir la imagen: $e');
      return null;
    }
  }

  // Crear documento del usuario en Firestore
  Future<void> createUserDocument(UserModel user) async {
    try {
      await _db
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .set(user.toMap());
    } catch (e) {
      debugPrint('Error al crear documento del usuario: $e');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Obtener UID actual
  String? getCurrentUid() => _auth.currentUser?.uid;

  Future<void> saveUserToFirestore(UserModel user, {File? profileImageFile}) async {
    try {
      String? imageUrl;

      //1. Sube la imagen de perfil si hay una nueva
      if (profileImageFile != null) {
        final storageRef = _storage.ref().child('profile_images/${user.uid}.jpg');
        final uploadTask = await storageRef.putFile(profileImageFile);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      //2. Crea una copia del modelo con la URL si se subió imagen
      final updateUser = user.copyWith(
        profileImageUrl: imageUrl ??  user.profileImageUrl,
      );

      //3. Guarda el documento en Firestore
      await _db.collection('users').doc(user.uid).set(updateUser.toMap());
    } catch (e) {
      throw Exception('Error al guardar usuario en Firestore: $e');
    }
  }
}
