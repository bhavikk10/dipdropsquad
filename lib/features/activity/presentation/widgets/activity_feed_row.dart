import 'package:flutter/cupertino.dart';

import '../../../../theme/app_colors.dart';

/// Activity list row: avatar (optional unread dot), username + action, time, thumbnail or FOLLOW BACK.
class ActivityFeedRow extends StatelessWidget {
  const ActivityFeedRow({super.key, required this.data});

  final Map<String, dynamic> data;

  static const Color _followBackBlue = Color(0xFF1C3A5F);

  @override
  Widget build(BuildContext context) {
    final username = data['username'] as String;
    final body = data['body'] as String;
    final time = (data['time'] as String).toUpperCase();
    final avatarUrl = data['avatarUrl'] as String?;
    final thumbnailUrl = data['thumbnailUrl'] as String?;
    final showUnreadDot = data['showUnreadDot'] as bool? ?? false;
    final followBack = data['followBack'] as bool? ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _Avatar(url: avatarUrl),
              if (showUnreadDot)
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.35,
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      TextSpan(
                        text: username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' $body',
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (followBack)
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _followBackBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'FOLLOW BACK',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    color: AppColors.background,
                  ),
                ),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: thumbnailUrl != null
                  ? Image.network(
                      thumbnailUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _thumbPlaceholder(),
                    )
                  : _thumbPlaceholder(),
            ),
        ],
      ),
    );
  }

  Widget _thumbPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.photo, size: 18, color: AppColors.textMuted),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: url != null
          ? Image.network(
              url!,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.person_fill, color: AppColors.textMuted, size: 24),
    );
  }
}
