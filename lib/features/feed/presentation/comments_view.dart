import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/mock_providers.dart';
import '../../../theme/app_colors.dart';
import 'widgets/comment_tile.dart';

/// Body-only comments thread + composer (no page chrome).
class CommentsView extends ConsumerStatefulWidget {
  const CommentsView({super.key});

  @override
  ConsumerState<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends ConsumerState<CommentsView> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsFeedProvider);
    final profile = ref.watch(editProfileProvider);
    final selfAvatar = profile['avatarUrl'] as String?;

    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return CommentTile(
                    comment: comments[index],
                    onReply: () {},
                    onLike: () {},
                  );
                },
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: selfAvatar != null
                          ? Image.network(
                              selfAvatar,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _selfAvatarFallback(),
                            )
                          : _selfAvatarFallback(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CupertinoTextField(
                        controller: _commentController,
                        placeholder: 'Add a comment...',
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        placeholderStyle: const TextStyle(color: AppColors.textMuted),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () {
                        _commentController.clear();
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selfAvatarFallback() {
    return Container(
      width: 32,
      height: 32,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.person_fill, color: AppColors.textMuted, size: 16),
    );
  }
}
