import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/core/utils/format_time.dart';
import 'package:println/models/comment_model.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/post/post_store.dart';
import 'package:provider/provider.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/core/services/api_service.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/view_models/post_details/post_details_store.dart';
import 'package:println/widgets/post_card.dart';

class PostDetailsPage extends StatefulWidget {

  final String postId;

  const PostDetailsPage({
    super.key,
    required this.postId,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {

  late PostDetailsStore store;
  late PostStore postStore;
  late AuthStore authStore;

  bool postEdited = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      postStore = context.read<PostStore>();
      authStore = context.read<AuthStore>();

      _initialized = true;
    }
  }

  @override
  void initState() {
    super.initState();

    store = PostDetailsStore(PostService(ApiService()));
    store.loadPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();

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

              final currentUserId = authStore.user?.id ?? "";

              return Column(
                children: [
                  Expanded(
                      child: ListView(
                        children: [

                          PostCard(
                            post: store.post!,
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
                            final isOwner = c.user.id == authStore.user?.id;

                            return ListTile(

                              leading: CircleAvatar(
                                backgroundImage: c.user.photo != null
                                    ? NetworkImage(c.user.photo!)
                                    : null,
                              ),

                              title: Row(
                                children: [
                                  Text(c.user.username),
                                  const SizedBox(width: 6),
                                  Text(
                                    "• ${formatTime(c.createdAt)}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  if (c.isEdited)
                                    const Text(
                                      " • editado",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                ],
                              ),

                              subtitle: Text(c.content),

                              trailing: isOwner
                                  ? PopupMenuButton(
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    value: "edit",
                                    child: Text("Editar"),
                                  ),
                                  const PopupMenuItem(
                                    value: "delete",
                                    child: Text("Excluir"),
                                  ),
                                ],
                                onSelected: (value) async {
                                  if (value == "edit") {
                                    _editCommentDialog(context, c);
                                  }

                                  if (value == "delete") {
                                    await store.deleteComment(
                                      c.id,
                                      authStore.user!.id,
                                    );
                                  }
                                },
                              )
                                  : null,

                            );

                          }),

                        ],
                      ),
                  ),
                  _CommentInput(
                    controller: commentController,
                    onSend: () async {
                      if (commentController.text.trim().isEmpty) return;

                      await store.addComment(
                        authStore.user!.id,
                        widget.postId,
                        commentController.text,
                      );

                      commentController.clear();
                    },
                  ),
                ],
              );

            },
          ),
        ),
    );
  }
}
class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _CommentInput({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final authStore = context.read<AuthStore>();
    final user = authStore.user;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [

            CircleAvatar(
              radius: 18,
              backgroundImage: user?.photo != null
                  ? NetworkImage(user!.photo!)
                  : null,
            ),

            const SizedBox(width: 8),

            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Adicione um comentário...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),

            IconButton(
              icon: const Icon(Icons.send),
              onPressed: onSend,
            )
          ],
        ),
      ),
    );
  }
}
void _editCommentDialog(BuildContext context, CommentModel comment) {
  final controller = TextEditingController(text: comment.content);
  final store = context.read<PostDetailsStore>();
  final authStore = context.read<AuthStore>();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Editar comentário"),
      content: TextField(
        controller: controller,
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () async {
            await store.editComment(
              comment.id,
              authStore.user!.id,
              controller.text,
            );

            Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),
      ],
    ),
  );
}