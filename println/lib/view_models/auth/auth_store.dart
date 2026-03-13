import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:println/data/repositories/auth_repository.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthRepository _repository = AuthRepository();

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