import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/core/ui/action_menu.dart';
import 'package:println/core/ui/app_dialog.dart';
import 'package:println/core/ui/app_snack_bar.dart';
import 'package:println/core/utils/format_time.dart';
import 'package:println/models/comment_model.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/post/post_store.dart';
import 'package:println/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/core/services/api_service.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/core/theme/app_colors.dart';
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
  late TextEditingController commentController;

  late PostDetailsStore detailsStore;
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

      detailsStore = PostDetailsStore(PostService(
          ApiService()),
      authStore
      );
      detailsStore.loadPost(widget.postId, postStore);

      _initialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
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

          appBar: CustomAppBar(
            title: "Detalhes do post",
            onBackTap: () {
              Navigator.pop(context, true);
            },
            showNotifications: false,
          ),

          body: Observer(
            builder: (_) {

              if (detailsStore.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (detailsStore.post == null) {
                return const Center(child: Text("Post não encontrado"));
              }


              return Column(
                children: [
                  Expanded(
                      child: ListView(
                        children: [

                          PostCard(
                            post: detailsStore.post!,
                            showOwnerActions: true,
                            disableCommentNavigation: true,

                            onEdit: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                AppRoutes.createPost,
                                arguments: {
                                  "postId": detailsStore.post!.id,
                                  "content": detailsStore.post!.content,
                                  "location": detailsStore.post!.location,
                                  "imageUrl": detailsStore.post!.imageUrl,
                                },
                              );

                              if (result == true) {
                                await detailsStore.loadPost(widget.postId, postStore);
                                postEdited = true;
                              }
                            },

                          ),

                          const Divider(),

                          ...detailsStore.comments.map((c) {
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
                                  ? ActionMenu(
                                onEdit: () async {
                                  commentController.text = c.content;
                                  detailsStore.editingCommentId = c.id;
                                  detailsStore.editingComment = c;
                                },

                                onDelete: () async {
                                  final confirmed = await AppDialog.confirm(
                                    context: context,
                                    title: "Excluir comentário",
                                    description: "Deseja realmente excluir este comentário?",
                                    confirmText: "Excluir",
                                    confirmColor: AppColors.danger,
                                    icon: Icons.delete,
                                    iconColor: AppColors.danger,
                                  );

                                  if (confirmed == true) {
                                    await detailsStore.deleteComment(
                                      c.id,
                                      authStore.user!.id,
                                      postStore,
                                    );

                                    if (detailsStore.error == null) {
                                      AppSnackbar.success("Comentário excluído");
                                    } else {
                                      AppSnackbar.error(detailsStore.error!);
                                    }
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
                    editingComment: detailsStore.editingComment,
                    onCancelEdit: () {
                      commentController.clear();
                      detailsStore.editingCommentId = null;
                      detailsStore.editingComment = null;
                    },
                    onSend: () async {
                      final text = commentController.text.trim();
                      if (text.isEmpty) return;

                      if (detailsStore.editingCommentId != null) {
                        await detailsStore.editComment(
                          detailsStore.editingCommentId!,
                          authStore.user!.id,
                          text,
                        );

                        if (detailsStore.error == null) {
                          AppSnackbar.success("Comentário atualizado");
                        } else {
                          AppSnackbar.error(detailsStore.error!);
                        }

                        commentController.clear();
                        detailsStore.editingCommentId = null;
                        detailsStore.editingComment = null;

                      } else {
                        await detailsStore.addComment(
                          authStore.user!.id,
                          widget.postId,
                          text,
                          postStore,
                        );

                        if (detailsStore.error == null) {
                          AppSnackbar.success("Comentário enviado");
                          commentController.clear();
                        } else {
                          AppSnackbar.error(detailsStore.error!);
                        }
                      }
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
  final VoidCallback onCancelEdit;
  final CommentModel? editingComment;

  const _CommentInput({
    required this.controller,
    required this.onSend,
    required this.onCancelEdit,
    required this.editingComment,
  });

  @override
  Widget build(BuildContext context) {
    final authStore = context.read<AuthStore>();
    final user = authStore.user;
    final theme = Theme.of(context);

    final isEditing = editingComment != null;

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            if (isEditing)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                color: theme.scaffoldBackgroundColor,
                child: Row(
                  children: [

                    GestureDetector(
                      onTap: onCancelEdit,
                      child: const Icon(Icons.cancel_outlined, color: AppColors.danger,),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Editando comentário",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            "'${editingComment!.content}'",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(8),
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
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: isEditing
                            ? "Editar comentário..."
                            : "Adicione um comentário...",
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(24),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  IconButton(
                    onPressed: onSend,
                    icon: Icon(
                      isEditing
                          ? Icons.check_circle
                          : Icons.send,
                    ),
                  ),
                ],
              ),
            ),
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