import 'package:flutter/cupertino.dart';

import '../../../../theme/app_colors.dart';

/// Row for followers / following lists.
class UserListTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool isFollowersTab;

  const UserListTile({
    super.key,
    required this.user,
    required this.isFollowersTab,
  });

  @override
  Widget build(BuildContext context) {
    final name = user['displayName'] as String;
    final username = user['username'] as String;
    final url = user['avatarUrl'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: url != null
                ? Image.network(
                    url,
                    width: 50,
                    height: 50,
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
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFollowersTab)
            CupertinoButton(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: Size.zero,
              onPressed: () {},
              child: const Text(
                'Remove',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            )
          else
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () {},
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Following',
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
  }

  Widget _avatarFallback() {
    return Container(
      width: 50,
      height: 50,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.person_fill, color: AppColors.textMuted, size: 24),
    );
  }
}
