import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/utils/responsive.dart';
import 'package:println/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:println/core/theme/app_spacing.dart';
import 'package:println/core/theme/app_text_styles.dart';
import 'package:println/core/utils/format_time.dart';
import 'package:println/core/utils/image_utils.dart';
import 'package:println/view_models/post/post_store.dart';


class PostCard extends StatelessWidget {

  final PostModel post;
  final PostStore postStore;
  final String currentUserId;

  const PostCard({
    super.key,
    required this.post,
    required this.postStore,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
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
                        ],
                      ),

                      if (post.location != null)
                        Text(
                          post.location!,
                          style: AppTextStyles.caption,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              post.content,
              style: AppTextStyles.body1,
            ),

            const SizedBox(height: AppSpacing.md),

            /// IMAGE
            if (post.imageUrl != null)
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.isDesktop(context) ? 500 : double.infinity,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: optimizeImage(post.imageUrl!),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
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

                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: "Comentar",
                  count: post.comments,
                ),

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
            )
          ],
        ),
      ),
    );
  }
}

// Usado internamente somente nesse widget
class _ActionButton extends StatelessWidget {

  final IconData icon;
  final String label;
  final int count;
  final VoidCallback? onTap;


  const _ActionButton({
    required this.icon,
    required this.label,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
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
    );
  }
}