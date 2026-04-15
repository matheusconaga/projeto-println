import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/core/services/api_service.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/post/post_store.dart';
import 'package:println/view_models/post_details/post_details_store.dart';
import 'package:println/widgets/post_card.dart';

class PostDetailsPage extends StatefulWidget {

  final String postId;
  final PostStore postStore;
  final AuthStore authStore;

  const PostDetailsPage({
    super.key,
    required this.postId,
    required this.postStore,
    required this.authStore,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {

  late PostDetailsStore store;
  bool postEdited = false;

  @override
  void initState() {
    super.initState();

    store = PostDetailsStore(PostService(ApiService()));
    store.loadPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(

        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          Navigator.pop(context, postEdited);

        },

        child: Scaffold(

          appBar: AppBar(
            title: const Text("Detalhes do post"),
          ),

          body: Observer(
            builder: (_) {

              if (store.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (store.post == null) {
                return const Center(child: Text("Post não encontrado"));
              }

              final currentUserId = widget.authStore.user?.id ?? "";

              return ListView(
                children: [

                  PostCard(
                    post: store.post!,
                    postStore: widget.postStore,
                    currentUserId: currentUserId,
                    authStore: widget.authStore,
                    showOwnerActions: true,

                    onEdit: () async {

                      final result = await Navigator.pushNamed(
                        context,
                        AppRoutes.createPost,
                        arguments: {
                          "postId": store.post!.id,
                          "content": store.post!.content,
                          "location": store.post!.location,
                          "imageUrl": store.post!.imageUrl,
                        },
                      );

                      if (result == true) {
                        await store.loadPost(widget.postId);
                        postEdited = true;
                      }
                    },
                  ),

                  const Divider(),

                  ...store.comments.map((c) {

                    return ListTile(

                      leading: CircleAvatar(
                        backgroundImage: c.user.photo != null
                            ? NetworkImage(c.user.photo!)
                            : null,
                      ),

                      title: Text(c.user.username),

                      subtitle: Text(c.content),

                    );

                  }),

                ],
              );
            },
          ),
        ),
    );
  }
}