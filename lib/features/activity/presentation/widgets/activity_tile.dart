import 'package:flutter/cupertino.dart';

import '../../../../theme/app_colors.dart';

/// Single activity row (like/comment thumbnail, follow, or request actions).
class ActivityTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const ActivityTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final username = data['username'] as String;
    final action = data['action'] as String;
    final time = data['time'] as String;
    final type = data['type'] as String;
    final avatarUrl = data['avatarUrl'] as String?;
    final thumbnailUrl = data['thumbnailUrl'] as String?;
    final showUnreadDot = data['showUnreadDot'] as bool? ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              _Avatar(url: avatarUrl),
              if (showUnreadDot)
                Positioned(
                  right: -2,
                  top: -2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(width: 10, height: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.35,
                  color: AppColors.textPrimary,
                ),
                children: [
                  TextSpan(
                    text: '$username ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: action,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: ' $time',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _Trailing(type: type, thumbnailUrl: thumbnailUrl),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? url;

  const _Avatar({this.url});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: url != null
          ? Image.network(
              url!,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 44,
      height: 44,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.person_fill, color: AppColors.textMuted, size: 22),
    );
  }
}

class _Trailing extends StatelessWidget {
  final String type;
  final String? thumbnailUrl;

  const _Trailing({required this.type, this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'likeComment':
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: thumbnailUrl != null
              ? Image.network(
                  thumbnailUrl!,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _thumbPlaceholder(),
                )
              : _thumbPlaceholder(),
        );
      case 'newFollower':
        return SizedBox(
          height: 32,
          child: CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            borderRadius: BorderRadius.circular(16),
            color: AppColors.accent,
            onPressed: () {},
            child: const Text(
              'Follow',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.background),
            ),
          ),
        );
      case 'followRequest':
        return SizedBox(
          height: 32,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                borderRadius: BorderRadius.circular(16),
                color: AppColors.accent,
                onPressed: () {},
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.background),
                ),
              ),
              const SizedBox(width: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: () {},
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox(width: 44, height: 44);
    }
  }

  Widget _thumbPlaceholder() {
    return Container(
      width: 44,
      height: 44,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.photo, size: 18, color: AppColors.textMuted),
    );
  }
}
