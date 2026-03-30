import 'package:flutter/cupertino.dart';

import '../../../../theme/app_colors.dart';

/// Single inbox thread row: avatar (optional dip badge), name, preview, time, unread count.
class InboxTile extends StatelessWidget {
  const InboxTile({
    super.key,
    required this.thread,
    this.onPressed,
    this.onProfilePressed,
  });

  final Map<String, dynamic> thread;
  final VoidCallback? onPressed;
  /// Opens `/profile/u/...` — typically avatar tap; row body still opens chat.
  final VoidCallback? onProfilePressed;

  static const Color _dipBadgeGreen = Color(0xFF2D6A4F);

  @override
  Widget build(BuildContext context) {
    final displayName = thread['displayName'] as String;
    final preview = thread['preview'] as String;
    final timestamp = thread['timestamp'] as String;
    final isUnread = thread['isUnread'] as bool;
    final avatarUrl = thread['avatarUrl'] as String?;
    final unreadCount = thread['unreadCount'] as int? ?? (isUnread ? 1 : 0);
    final showDipBadge = thread['showDipBadge'] as bool? ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onProfilePressed,
            behavior: HitTestBehavior.opaque,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: avatarUrl != null
                      ? Image.network(
                          avatarUrl,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _avatarFallback(),
                        )
                      : _avatarFallback(),
                ),
                if (showDipBadge)
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: _dipBadgeGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.tag_fill,
                        size: 11,
                        color: AppColors.background,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onPressed,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isUnread ? FontWeight.w700 : FontWeight.w400,
                        color: isUnread ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onPressed,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timestamp,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(height: 6),
                  Container(
                    constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.background,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      width: 54,
      height: 54,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.person_fill, color: AppColors.textMuted, size: 26),
    );
  }
}
