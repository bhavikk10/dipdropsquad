import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/mock_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';

/// Followers / following list (mock). Opened from profile stats.
class FollowConnectionsScreen extends ConsumerStatefulWidget {
  const FollowConnectionsScreen({
    super.key,
    required this.profileHandle,
    required this.displayName,
    this.initialTab = 0,
  });

  final String profileHandle;
  final String displayName;
  final int initialTab;

  static const _canvas = Color(0xFFF5F5F7);
  static const _slateBlue = Color(0xFF2E4A8A);

  @override
  ConsumerState<FollowConnectionsScreen> createState() => _FollowConnectionsScreenState();
}

class _FollowConnectionsScreenState extends ConsumerState<FollowConnectionsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final i = widget.initialTab.clamp(0, 1);
    _tabController = TabController(length: 2, vsync: this, initialIndex: i);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final followers = ref.watch(followersForHandleProvider(widget.profileHandle));
    final following = ref.watch(followingForHandleProvider(widget.profileHandle));

    return Scaffold(
      backgroundColor: FollowConnectionsScreen._canvas,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(AppIcons.backChevron, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.displayName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: FollowConnectionsScreen._canvas,
            child: TabBar(
              controller: _tabController,
              indicatorColor: FollowConnectionsScreen._slateBlue,
              indicatorWeight: 3,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              tabs: const [
                Tab(text: 'Followers'),
                Tab(text: 'Following'),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.search, color: AppColors.textPrimary, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ConnectionsList(users: followers),
          _ConnectionsList(users: following),
        ],
      ),
    );
  }
}

class _ConnectionsList extends StatelessWidget {
  const _ConnectionsList({required this.users});

  final List<Map<String, dynamic>> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _ConnectionRow(user: users[index]);
      },
    );
  }
}

class _ConnectionRow extends StatefulWidget {
  const _ConnectionRow({required this.user});

  final Map<String, dynamic> user;

  @override
  State<_ConnectionRow> createState() => _ConnectionRowState();
}

class _ConnectionRowState extends State<_ConnectionRow> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user['isFollowing'] as bool? ?? false;
  }

  static const _slateBlue = Color(0xFF2E4A8A);

  @override
  Widget build(BuildContext context) {
    final name = widget.user['displayName'] as String;
    final username = widget.user['username'] as String;
    final url = widget.user['avatarUrl'] as String?;
    final badge = widget.user['badge'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipOval(
                child: url != null
                    ? Image.network(
                        url,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarPh(),
                      )
                    : _avatarPh(),
              ),
              if (badge == 'gold')
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC9A227),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.star_fill, size: 11, color: Colors.white),
                  ),
                )
              else if (badge == 'green')
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF34C759),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.check_mark, size: 11, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
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
          TextButton(
            onPressed: () => setState(() => _isFollowing = !_isFollowing),
            style: TextButton.styleFrom(
              backgroundColor: _isFollowing ? const Color(0xFFE8E8EC) : _slateBlue,
              foregroundColor: _isFollowing ? AppColors.textMuted : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              _isFollowing ? 'Following' : 'Follow',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPh() {
    return Container(
      width: 54,
      height: 54,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.person_fill, color: AppColors.textMuted, size: 26),
    );
  }
}
