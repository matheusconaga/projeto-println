// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  late final _$isLoggedAtom = Atom(
    name: '_AuthStore.isLogged',
    context: context,
  );

  @override
  bool get isLogged {
    _$isLoggedAtom.reportRead();
    return super.isLogged;
  }

  @override
  set isLogged(bool value) {
    _$isLoggedAtom.reportWrite(value, super.isLogged, () {
      super.isLogged = value;
    });
  }

  late final _$loadingAtom = Atom(name: '_AuthStore.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$userAtom = Atom(name: '_AuthStore.user', context: context);

  @override
  UserModel? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$checkAuthAsyncAction = AsyncAction(
    '_AuthStore.checkAuth',
    context: context,
  );

  @override
  Future<dynamic> checkAuth() {
    return _$checkAuthAsyncAction.run(() => super.checkAuth());
  }

  late final _$checkEmailAsyncAction = AsyncAction(
    '_AuthStore.checkEmail',
    context: context,
  );

  @override
  Future<bool> checkEmail(String email) {
    return _$checkEmailAsyncAction.run(() => super.checkEmail(email));
  }

  late final _$registerAsyncAction = AsyncAction(
    '_AuthStore.register',
    context: context,
  );

  @override
  Future<dynamic> register(
    String email,
    String password,
    String username,
    File? photo,
    Uint8List? webPhoto,
  ) {
    return _$registerAsyncAction.run(
      () => super.register(email, password, username, photo, webPhoto),
    );
  }

  late final _$loginAsyncAction = AsyncAction(
    '_AuthStore.login',
    context: context,
  );

  @override
  Future<dynamic> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_AuthStore.logout',
    context: context,
  );

  @override
  Future<dynamic> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  @override
  String toString() {
    return '''
isLogged: ${isLogged},
loading: ${loading},
user: ${user}
    ''';
  }
}
