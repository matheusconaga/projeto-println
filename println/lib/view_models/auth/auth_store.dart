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
  final UserRepository _userRepository = UserRepository();

  late final Stream<User?> _authStream;

  _AuthStore() {
    _authStream = _repository.authStateChanges();
    _authStream.listen((firebaseUser) async {
      isLogged = firebaseUser != null;

      if (firebaseUser != null) {
        user = await _userRepository.getUserById(firebaseUser.uid);
      } else {
        user = null;
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
  Future checkAuth() async {
    loading = true;
    final firebaseUser = _repository.getCurrentUser();
    isLogged = firebaseUser != null;

    if (firebaseUser != null) {
      user = await _userRepository.getUserById(firebaseUser.uid);
    } else {
      user = null;
    }

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
      final userId = credential.user!;

      final newUser = await _userRepository.registerUser(
        id: userId.uid,
        email: email,
        username: username,
        photo: photo,
        webPhoto: webPhoto,
      );

      user = newUser;

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
      user = await _userRepository.getUserById(firebaseUser.uid);
    } finally {
      loading = false;
    }
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
      final updatedUser = await _userRepository.updateUser(
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
      user = null;
    } finally {
      loading = false;
    }
  }
}