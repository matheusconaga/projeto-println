// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostStore on _PostStore, Store {
  late final _$loadingAtom = Atom(name: '_PostStore.loading', context: context);

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

  late final _$errorAtom = Atom(name: '_PostStore.error', context: context);

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

  late final _$createPostAsyncAction = AsyncAction(
    '_PostStore.createPost',
    context: context,
  );

  @override
  Future<void> createPost({
    required String content,
    String? location,
    File? selectedImage,
    Uint8List? webImage,
  }) {
    return _$createPostAsyncAction.run(
      () => super.createPost(
        content: content,
        location: location,
        selectedImage: selectedImage,
        webImage: webImage,
      ),
    );
  }

  late final _$editPostAsyncAction = AsyncAction(
    '_PostStore.editPost',
    context: context,
  );

  @override
  Future<void> editPost({
    required String postId,
    required String content,
    String? location,
    File? selectedImage,
    Uint8List? webImage,
  }) {
    return _$editPostAsyncAction.run(
      () => super.editPost(
        postId: postId,
        content: content,
        location: location,
        selectedImage: selectedImage,
        webImage: webImage,
      ),
    );
  }

  late final _$deletePostAsyncAction = AsyncAction(
    '_PostStore.deletePost',
    context: context,
  );

  @override
  Future<void> deletePost(String postId) {
    return _$deletePostAsyncAction.run(() => super.deletePost(postId));
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error}
    ''';
  }
}
