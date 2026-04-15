import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:println/data/repositories/auth_repository.dart';
import 'dart:io';
import 'package:println/data/repositories/user_repository.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:println/models/user_model.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthRepository _repository = AuthRepository();
  final UserRepository userRepository = UserRepository();

  late final Stream<User?> _authStream;

  _AuthStore() {
    _authStream = _repository.authStateChanges();
    _authStream.listen((firebaseUser) async {
      if (firebaseUser == null) {
        runInAction(() {
          user = null;
          isLogged = false;
        });
        return;
      }

      final backendUser = await waitForUserInBackend(
        firebaseUser.uid,
        timeout: const Duration(seconds: 10),
      );

      if (backendUser != null) {
        runInAction(() {
          user = backendUser;
          isLogged = true;
        });
      }
    });
  }

  @observable
  bool isLogged = false;

  @observable
  bool loading = false;

  @observable
  UserModel? user;

  @action
  User? getFirebaseUser() {
    return _repository.getCurrentUser();
  }

  @action
  Future<void> checkAuth() async {
    loading = true;
    try {
      final firebaseUser = _repository.getCurrentUser();

      if (firebaseUser != null) {
        final backendUser = await waitForUserInBackend(
          firebaseUser.uid,
          timeout: const Duration(seconds: 10),
        );

        runInAction(() {
          user = backendUser;
          isLogged = backendUser != null;
        });
      } else {
        runInAction(() {
          user = null;
          isLogged = false;
        });
      }
    } catch (e) {
      debugPrint("Erro no checkAuth: $e");
      runInAction(() {
        user = null;
        isLogged = false;
      });
    } finally {
      loading = false;
    }
  }

  @action
  Future<bool> checkEmail(String email) async {
    return await userRepository.checkEmail(email);
  }

  @action
  Future<UserCredential> register(
      String email,
      String password,
      String username,
      File? photo,
      Uint8List? webPhoto,
      ) async {
    loading = true;
    try {
      final credential = await _repository.register(email, password);
      final firebaseUser = credential.user!;

      final newUser = await userRepository.registerUser(
        id: firebaseUser.uid,
        email: email,
        username: username,
        photo: photo,
        webPhoto: webPhoto,
      );

      runInAction(() {
        user = newUser;
        isLogged = true;
      });

      return credential;
    } catch (e) {
      runInAction(() {
        user = null;
        isLogged = false;
      });
      rethrow;
    } finally {
      loading = false;
    }
  }

  @action
  Future login(String email, String password) async {
    loading = true;
    try {
      final credential = await _repository.login(email, password);
      final firebaseUser = credential.user!;

      final backendUser = await waitForUserInBackend(
        firebaseUser.uid,
        timeout: const Duration(seconds: 10),
      );

      runInAction(() {
        user = backendUser;
        isLogged = backendUser != null;
      });
    } catch (e) {
      runInAction(() {
        user = null;
        isLogged = false;
      });
      rethrow;
    } finally {
      loading = false;
    }
  }

  @action
  Future<UserModel?> waitForUserInBackend(
      String uid, {
        Duration timeout = const Duration(seconds: 5),
      }) async {
    const intervalMs = 100;
    var elapsed = 0;

    while (elapsed < timeout.inMilliseconds) {
      final fetchedUser = await userRepository.getUserById(uid);
      if (fetchedUser != null) return fetchedUser;

      await Future.delayed(const Duration(milliseconds: intervalMs));
      elapsed += intervalMs;
    }

    return null;
  }

  @action
  Future<void> updateUser({
    required String userId,
    String? username,
    File? photo,
    Uint8List? webPhoto,
    bool removePhoto = false,
  }) async {
    if (userId.isEmpty) return;

    loading = true;
    try {
      final updatedUser = await userRepository.updateUser(
        userId,
        username,
        photo,
        webPhoto,
        removePhoto: removePhoto,
      );

      user = updatedUser;
    } finally {
      loading = false;
    }
  }

  @action
  Future logout() async {
    loading = true;
    try {
      await _repository.logout();
      runInAction(() {
        user = null;
        isLogged = false;
      });
    } finally {
      loading = false;
    }
  }
}