import 'dart:io';
import 'dart:typed_data';

import 'package:mobx/mobx.dart';
import 'package:println/core/services/api_service.dart';
import 'package:println/models/user_model.dart';

import '../../core/services/auth_api_service.dart';
import '../../core/services/secure_storage_service.dart';
import '../../data/repositories/user_repository.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final authApi = AuthApiService(ApiService());
  final storage = SecureStorageService();
  final userRepository = UserRepository();

  @observable
  bool isLogged = false;

  @observable
  bool loading = false;

  @observable
  UserModel? user;

  @observable
  String? message;

  @observable
  String? messageType;

  @action
  void setMessage(String msg, String type) {
    message = msg;
    messageType = type;
  }

  @action
  Future<bool> checkEmail(String email) async {
    return await userRepository.checkEmail(email);
  }

  @action
  Future<void> checkAuth() async {
    loading = true;

    try {
      final token = await storage.getToken();

      if (token == null) {
        isLogged = false;
        user = null;
        return;
      }

      user = await userRepository.getMe();
      isLogged = true;
    } catch (_) {
      await storage.logout();
      isLogged = false;
      user = null;
    }

    loading = false;
  }

  @action
  Future<void> login(String email, String password) async {
    loading = true;

    try {
      final token = await authApi.login(
        email: email,
        password: password,
      );

      await storage.saveToken(token);

      user = await userRepository.getMe();
      isLogged = true;

      setMessage("Login realizado com sucesso!", "success");
    } catch (_) {
      isLogged = false;
      user = null;

      setMessage("Erro ao fazer login", "error");
    }

    loading = false;
  }

  @action
  Future<void> register(
      String email,
      String password,
      String username,
      File? photo,
      Uint8List? webPhoto,
      ) async {
    loading = true;

    try {
      final token = await authApi.register(
        email: email,
        password: password,
        username: username,
      );

      await storage.saveToken(token);

      user = await userRepository.getMe();

      isLogged = true;

      setMessage("Conta criada com sucesso!", "success");
    } catch (_) {
      isLogged = false;
      user = null;

      setMessage("Erro ao criar conta", "error");
    }

    loading = false;
  }

  @action
  Future<void> updateUser({
    String? username,
    File? photo,
    Uint8List? webPhoto,
    bool removePhoto = false,
  }) async {
    loading = true;

    try {
      final updatedUser = await userRepository.updateUser(
        username,
        photo,
        webPhoto,
        removePhoto: removePhoto,
      );

      user = updatedUser;

      setMessage("Perfil atualizado!", "success");
    } catch (_) {
      setMessage("Erro ao atualizar perfil", "error");
    }

    loading = false;
  }

  @action
  Future<void> logout() async {
    await storage.logout();

    user = null;
    isLogged = false;

    setMessage("Logout realizado", "success");
  }
}