import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_icons.dart';

/// Single comment row in [CommentsView].
class CommentTile extends StatelessWidget {
  final Map<String, dynamic> comment;
  final VoidCallback? onReply;
  final VoidCallback? onLike;

  const CommentTile({
    super.key,
    required this.comment,
    this.onReply,
    this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final username = comment['username'] as String;
    final time = comment['time'] as String;
    final body = comment['body'] as String;
    final avatarUrl = comment['avatarUrl'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatarFallback(),
                  )
                : _avatarFallback(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: AppTypography.bodyPrimary.copyWith(fontSize: 13, height: 1.2),
                      children: [
                        TextSpan(
                          text: username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' • $time',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      body,
                      style: AppTypography.bodyPrimary.copyWith(height: 1.35),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 20),
                    onPressed: onReply,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Reply',
                      style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onLike,
            child: const Icon(
              AppIcons.heartOutline,
              size: 16,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      width: 36,
      height: 36,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(AppIcons.person, color: AppColors.textMuted, size: 18),
    );
  }
}
