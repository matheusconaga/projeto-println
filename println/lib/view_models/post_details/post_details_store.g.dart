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

  late final _$sendingCommentAtom = Atom(
    name: '_PostDetailsStore.sendingComment',
    context: context,
  );

  @override
  bool get sendingComment {
    _$sendingCommentAtom.reportRead();
    return super.sendingComment;
  }

  @override
  set sendingComment(bool value) {
    _$sendingCommentAtom.reportWrite(value, super.sendingComment, () {
      super.sendingComment = value;
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

  late final _$editingCommentIdAtom = Atom(
    name: '_PostDetailsStore.editingCommentId',
    context: context,
  );

  @override
  String? get editingCommentId {
    _$editingCommentIdAtom.reportRead();
    return super.editingCommentId;
  }

  @override
  set editingCommentId(String? value) {
    _$editingCommentIdAtom.reportWrite(value, super.editingCommentId, () {
      super.editingCommentId = value;
    });
  }

  late final _$editingCommentAtom = Atom(
    name: '_PostDetailsStore.editingComment',
    context: context,
  );

  @override
  CommentModel? get editingComment {
    _$editingCommentAtom.reportRead();
    return super.editingComment;
  }

  @override
  set editingComment(CommentModel? value) {
    _$editingCommentAtom.reportWrite(value, super.editingComment, () {
      super.editingComment = value;
    });
  }

  late final _$loadPostAsyncAction = AsyncAction(
    '_PostDetailsStore.loadPost',
    context: context,
  );

  @override
  Future<void> loadPost(String postId, PostStore postStore) {
    return _$loadPostAsyncAction.run(() => super.loadPost(postId, postStore));
  }

  late final _$addCommentAsyncAction = AsyncAction(
    '_PostDetailsStore.addComment',
    context: context,
  );

  @override
  Future<void> addComment(
    String userId,
    String postId,
    String content,
    PostStore postStore,
  ) {
    return _$addCommentAsyncAction.run(
      () => super.addComment(userId, postId, content, postStore),
    );
  }

  late final _$editCommentAsyncAction = AsyncAction(
    '_PostDetailsStore.editComment',
    context: context,
  );

  @override
  Future<void> editComment(String commentId, String userId, String content) {
    return _$editCommentAsyncAction.run(
      () => super.editComment(commentId, userId, content),
    );
  }

  late final _$deleteCommentAsyncAction = AsyncAction(
    '_PostDetailsStore.deleteComment',
    context: context,
  );

  @override
  Future<void> deleteComment(
    String commentId,
    String userId,
    PostStore postStore,
  ) {
    return _$deleteCommentAsyncAction.run(
      () => super.deleteComment(commentId, userId, postStore),
    );
  }

  @override
  String toString() {
    return '''
post: ${post},
comments: ${comments},
sendingComment: ${sendingComment},
loading: ${loading},
error: ${error},
editingCommentId: ${editingCommentId},
editingComment: ${editingComment}
    ''';
  }
}
