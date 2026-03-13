import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_service.dart';
import 'user_api_service.dart';

class AuthService {

  final FirebaseAuthService firebase;
  final UserApiService api;

  AuthService(this.firebase, this.api);

  Future<void> authenticate({
    required String email,
    required String password,
    String? username,
  }) async {

    final exists = await api.checkEmail(email);

    // Se o email existir ele faz o fluxo do login
    if (exists) {

      await firebase.login(email, password);

      // Se o email nao existir ele faz o fluxo do cadastro
    } else {

      final credential = await firebase.register(email, password);

      final user = credential.user!;

      await api.registerUser(
        firebaseUid: user.uid,
        email: user.email!,
        username: username!,
        photo: user.photoURL,
      );
    }
  }
}