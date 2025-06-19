import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindmate/features/auth/services/auth_service.dart';
import 'package:mindmate/models/user_model.dart';
import 'package:riverpod/riverpod.dart';


/* Proveedor de la instancia de AuthService 
 * (para inyectarlo donde lo necesitemos) */
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Estado para el usuario actual
final authUserProvider = StateProvider<User?>(
  (ref) => FirebaseAuth.instance.currentUser,
);

// Controlador de autenticación principal
final authControllerProvider = Provider<AuthController>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthController(ref, authService);
});

// Clase encargada de controlar la lógica de autenticación
class AuthController {
  final Ref ref;
  final AuthService _authService;

  AuthController(this.ref, this._authService);

  // Registro de usuario con email y contraseña
  Future<User?> registerUser({
    required String email,
    required String password,
  }) async {
    final user = await _authService.registerWithEmail(email, password);
    if (user != null) {
      ref.read(authUserProvider.notifier).state = user;
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
      ref.read(authUserProvider.notifier).state = user;
    }
    return user;
  }

  // Login con Google
  Future<User?> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      ref.read(authUserProvider.notifier).state = user;
    }
    return user;
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
    ref.read(authUserProvider.notifier).state = null;
  }

  // UID del usuario actual
  String? get currentUID => _authService.getCurrentUid();
}
