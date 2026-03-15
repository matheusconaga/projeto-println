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

  late final _$likedPostsAtom = Atom(
    name: '_PostStore.likedPosts',
    context: context,
  );

  @override
  ObservableMap<String, bool> get likedPosts {
    _$likedPostsAtom.reportRead();
    return super.likedPosts;
  }

  @override
  set likedPosts(ObservableMap<String, bool> value) {
    _$likedPostsAtom.reportWrite(value, super.likedPosts, () {
      super.likedPosts = value;
    });
  }

  late final _$postLikesAtom = Atom(
    name: '_PostStore.postLikes',
    context: context,
  );

  @override
  ObservableMap<String, int> get postLikes {
    _$postLikesAtom.reportRead();
    return super.postLikes;
  }

  @override
  set postLikes(ObservableMap<String, int> value) {
    _$postLikesAtom.reportWrite(value, super.postLikes, () {
      super.postLikes = value;
    });
  }

  late final _$savedPostsAtom = Atom(
    name: '_PostStore.savedPosts',
    context: context,
  );

  @override
  ObservableMap<String, bool> get savedPosts {
    _$savedPostsAtom.reportRead();
    return super.savedPosts;
  }

  @override
  set savedPosts(ObservableMap<String, bool> value) {
    _$savedPostsAtom.reportWrite(value, super.savedPosts, () {
      super.savedPosts = value;
    });
  }

  late final _$postSavesAtom = Atom(
    name: '_PostStore.postSaves',
    context: context,
  );

  @override
  ObservableMap<String, int> get postSaves {
    _$postSavesAtom.reportRead();
    return super.postSaves;
  }

  @override
  set postSaves(ObservableMap<String, int> value) {
    _$postSavesAtom.reportWrite(value, super.postSaves, () {
      super.postSaves = value;
    });
  }

  late final _$feedPostsAtom = Atom(
    name: '_PostStore.feedPosts',
    context: context,
  );

  @override
  ObservableList<PostModel> get feedPosts {
    _$feedPostsAtom.reportRead();
    return super.feedPosts;
  }

  @override
  set feedPosts(ObservableList<PostModel> value) {
    _$feedPostsAtom.reportWrite(value, super.feedPosts, () {
      super.feedPosts = value;
    });
  }

  late final _$toggleLikeAsyncAction = AsyncAction(
    '_PostStore.toggleLike',
    context: context,
  );

  @override
  Future<void> toggleLike(String postId, String userId) {
    return _$toggleLikeAsyncAction.run(() => super.toggleLike(postId, userId));
  }

  late final _$initializeLikesAsyncAction = AsyncAction(
    '_PostStore.initializeLikes',
    context: context,
  );

  @override
  Future<void> initializeLikes(
    String currentUserId, {
    List<PostModel>? feedPosts,
  }) {
    return _$initializeLikesAsyncAction.run(
      () => super.initializeLikes(currentUserId, feedPosts: feedPosts),
    );
  }

  late final _$toggleSaveAsyncAction = AsyncAction(
    '_PostStore.toggleSave',
    context: context,
  );

  @override
  Future<void> toggleSave(String postId, String userId) {
    return _$toggleSaveAsyncAction.run(() => super.toggleSave(postId, userId));
  }

  late final _$initializeSavesAsyncAction = AsyncAction(
    '_PostStore.initializeSaves',
    context: context,
  );

  @override
  Future<void> initializeSaves(String currentUserId) {
    return _$initializeSavesAsyncAction.run(
      () => super.initializeSaves(currentUserId),
    );
  }

  late final _$createPostAsyncAction = AsyncAction(
    '_PostStore.createPost',
    context: context,
  );

  @override
  Future<bool> createPost({
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
    bool removeImage = false,
  }) {
    return _$editPostAsyncAction.run(
      () => super.editPost(
        postId: postId,
        content: content,
        location: location,
        selectedImage: selectedImage,
        webImage: webImage,
        removeImage: removeImage,
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

  late final _$_PostStoreActionController = ActionController(
    name: '_PostStore',
    context: context,
  );

  @override
  void setFeed(List<PostModel> posts) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
      name: '_PostStore.setFeed',
    );
    try {
      return super.setFeed(posts);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
likedPosts: ${likedPosts},
postLikes: ${postLikes},
savedPosts: ${savedPosts},
postSaves: ${postSaves},
feedPosts: ${feedPosts}
    ''';
  }
}
