import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/mock_providers.dart';
import '../../../theme/app_colors.dart';
import 'widgets/user_list_tile.dart';

/// Body-only followers/following list (no page chrome).
class FollowListView extends ConsumerStatefulWidget {
  const FollowListView({super.key});

  @override
  ConsumerState<FollowListView> createState() => _FollowListViewState();
}

class _FollowListViewState extends ConsumerState<FollowListView> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(followListUsersProvider);

    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _segment,
                backgroundColor: AppColors.surface,
                thumbColor: AppColors.background,
                onValueChanged: (v) {
                  if (v != null) setState(() => _segment = v);
                },
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Followers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Following',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: CupertinoSearchTextField(
              placeholder: 'Search',
              backgroundColor: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              style: const TextStyle(color: AppColors.textPrimary),
              placeholderStyle: const TextStyle(color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserListTile(
                  user: users[index],
                  isFollowersTab: _segment == 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
