// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_posts_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SavedPostsStore on _SavedPostsStore, Store {
  late final _$savedPostsAtom = Atom(
    name: '_SavedPostsStore.savedPosts',
    context: context,
  );

  @override
  ObservableList<PostModel> get savedPosts {
    _$savedPostsAtom.reportRead();
    return super.savedPosts;
  }

  @override
  set savedPosts(ObservableList<PostModel> value) {
    _$savedPostsAtom.reportWrite(value, super.savedPosts, () {
      super.savedPosts = value;
    });
  }

  late final _$loadingAtom = Atom(
    name: '_SavedPostsStore.loading',
    context: context,
  );

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

  late final _$errorAtom = Atom(
    name: '_SavedPostsStore.error',
    context: context,
  );

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$loadSavedPostsAsyncAction = AsyncAction(
    '_SavedPostsStore.loadSavedPosts',
    context: context,
  );

  @override
  Future<void> loadSavedPosts(String userId) {
    return _$loadSavedPostsAsyncAction.run(() => super.loadSavedPosts(userId));
  }

  @override
  String toString() {
    return '''
savedPosts: ${savedPosts},
loading: ${loading},
error: ${error}
    ''';
  }
}
