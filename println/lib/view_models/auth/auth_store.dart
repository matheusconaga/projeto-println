import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:println/data/repositories/auth_repository.dart';
import 'dart:io';
import 'package:println/data/repositories/user_repository.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthRepository _repository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  late final Stream<User?> _authStream;

  _AuthStore() {
    _authStream = _repository.authStateChanges();
    _authStream.listen((user) {
      isLogged = user != null;
    });
  }

  @observable
  bool isLogged = false;

  @observable
  bool loading = false;

  @action
  Future checkAuth() async {
    loading = true;
    final user = _repository.getCurrentUser();
    isLogged = user != null;
    loading = false;
  }

  @action
  Future<bool> checkEmail(String email) async {
    return await _userRepository.checkEmail(email);
  }

  @action
  Future register(
      String email,
      String password,
      String username,
      File? photo,
      Uint8List? webPhoto,
      ) async {

    loading = true;

    try {

      final credential = await _repository.register(email, password);
      final user = credential.user!;

      await _userRepository.registerUser(
        firebaseUid: user.uid,
        email: email,
        username: username,
        photo: photo,
        webPhoto: webPhoto,

      );

    } finally {

      loading = false;

    }

  }

  @action
  Future login(String email, String password) async {
    loading = true;
    try {
      await _repository.login(email, password);
    } finally {
      loading = false;
    }
  }

  @action
  Future logout() async {
    loading = true;
    try {
      await _repository.logout();
    } finally {
      loading = false;
    }
  }
}