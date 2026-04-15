// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PostDetailsStore on _PostDetailsStore, Store {
  late final _$postAtom = Atom(
    name: '_PostDetailsStore.post',
    context: context,
  );

  @override
  PostModel? get post {
    _$postAtom.reportRead();
    return super.post;
  }

  @override
  set post(PostModel? value) {
    _$postAtom.reportWrite(value, super.post, () {
      super.post = value;
    });
  }

  late final _$commentsAtom = Atom(
    name: '_PostDetailsStore.comments',
    context: context,
  );

  @override
  ObservableList<CommentModel> get comments {
    _$commentsAtom.reportRead();
    return super.comments;
  }

  @override
  set comments(ObservableList<CommentModel> value) {
    _$commentsAtom.reportWrite(value, super.comments, () {
      super.comments = value;
    });
  }

  late final _$loadingAtom = Atom(
    name: '_PostDetailsStore.loading',
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
    name: '_PostDetailsStore.error',
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

  late final _$loadPostAsyncAction = AsyncAction(
    '_PostDetailsStore.loadPost',
    context: context,
  );

  @override
  Future<void> loadPost(String postId) {
    return _$loadPostAsyncAction.run(() => super.loadPost(postId));
  }

  @override
  String toString() {
    return '''
post: ${post},
comments: ${comments},
loading: ${loading},
error: ${error}
    ''';
  }
}
