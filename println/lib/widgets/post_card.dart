import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/ui/app_dialog.dart';
import 'package:println/core/utils/responsive.dart';
import 'package:println/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:println/core/theme/app_spacing.dart';
import 'package:println/core/theme/app_text_styles.dart';
import 'package:println/core/utils/format_time.dart';
import 'package:println/core/utils/image_utils.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/feed/feed_store.dart';
import 'package:println/view_models/post/post_store.dart';

import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;
  final bool showOwnerActions;
  final Future<void> Function()? onEdit;
  final bool disableCommentNavigation;

  const PostCard({
    super.key,
    required this.post,
    this.showOwnerActions = false,
    this.onEdit,
    this.onTap,
    this.disableCommentNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    final postStore = context.read<PostStore>();
    final authStore = context.read<AuthStore>();

    final feedStore = context.read<FeedStore?>();

    final currentUserId = authStore.user?.id ?? "";

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isOwner =
        currentUserId.isNotEmpty &&
        post.user?.id == currentUserId &&
        showOwnerActions;

    return GestureDetector(
      onTap: disableCommentNavigation ? null : onTap,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: post.user?.photo != null
                        ? NetworkImage(post.user!.photo!)
                        : null,
                    backgroundColor: isDark
                        ? DarkColors.surface
                        : LightColors.background,
                    child: post.user?.photo == null
                        ? Icon(
                            Icons.person,
                            color: isDark ? Colors.white : Colors.black,
                          )
                        : null,
                  ),

                  const SizedBox(width: AppSpacing.md),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              post.user?.username ?? "Desconhecido",
                              style: AppTextStyles.heading2,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "• ${formatTime(post.createdAt)}",
                              style: AppTextStyles.caption,
                            ),
                            if (post.isEdited)
                              const Text(
                                " • editado",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),

                        if (post.location != null)
                          Text(post.location!, style: AppTextStyles.caption),
                      ],
                    ),
                  ),

                  /// MENU DONO
                  if (isOwner)
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == "edit") {
                          await onEdit?.call();
                        }

                        if (value == "delete") {
                          final confirmed = await AppDialog.confirm(
                            context: context,
                            title: "Excluir post",
                            description: "Deseja realmente excluir?",
                            confirmText: "Excluir",
                            confirmColor: Colors.red,
                            icon: Icons.delete,
                            iconColor: Colors.red,
                          );

                          if (confirmed == true) {

                            await postStore.deletePost(post.id);

                            feedStore?.posts.removeWhere((p) => p.id == post.id);

                            if (!context.mounted) return;

                            Navigator.pop(context, true);
                          }
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: "edit", child: Text("Editar")),
                        PopupMenuItem(value: "delete", child: Text("Excluir")),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              /// CONTENT
              Text(post.content, style: AppTextStyles.body1),

              const SizedBox(height: AppSpacing.md),

              /// IMAGE
              if (post.imageUrl != null)
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.isDesktop(context)
                          ? 500
                          : double.infinity,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: optimizeImage(post.imageUrl!),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.md),

              /// ACTIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// LIKE
                  Observer(
                    builder: (_) => _ActionButton(
                      icon: postStore.likedPosts[post.id] == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: "Curtir",
                      count: postStore.postLikes[post.id] ?? post.likes,
                      onTap: () => postStore.toggleLike(post.id, currentUserId),
                    ),
                  ),

                  /// COMMENT
                  Observer(
                    builder: (_) => _ActionButton(
                      icon: Icons.chat_bubble_outline,
                      label: "Comentar",
                      count: postStore.postComments[post.id] ?? post.comments,
                      onTap: disableCommentNavigation
                          ? null
                          : () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.detailsPost,
                                arguments: {"postId": post.id},
                              );
                            },
                    ),
                  ),

                  /// SAVE
                  Observer(
                    builder: (_) => _ActionButton(
                      icon: postStore.savedPosts[post.id] == true
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      label: "Salvar",
                      count: postStore.postSaves[post.id] ?? post.saves,
                      onTap: () => postStore.toggleSave(post.id, currentUserId),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final VoidCallback? onTap;
  final bool enabled;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.count,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 6),
                Text(count.toString(), style: AppTextStyles.body2),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
