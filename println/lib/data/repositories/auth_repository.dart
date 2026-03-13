import 'package:firebase_auth/firebase_auth.dart';
import 'package:println/core/services/firebase_auth_service.dart';

class AuthRepository {

  final FirebaseAuthService _service = FirebaseAuthService();

  User? getCurrentUser() {
    return _service.getCurrentUser();
  }

  Stream<User?> authStateChanges() {
    return _service.authStateChanges();
  }

  Future<UserCredential> register(
      String email,
      String password,
      ) {

    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

  }

  Future<UserCredential> login(String email, String password) {
    return _service.login(email, password);
  }

  Future<void> logout() {
    return _service.logout();
  }
}