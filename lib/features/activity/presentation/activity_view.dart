import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/mock_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadows.dart';
import 'widgets/activity_feed_row.dart';

/// Activity body: All / Purchases (0–1) or follow-requests (2).
class ActivityView extends ConsumerWidget {
  const ActivityView({super.key, required this.tabIndex});

  final int tabIndex;

  static const _tabKeys = ['all', 'purchases'];
  static const _feedCanvas = Color(0xFFF5F5F7);
  static const _sectionOrder = ['yesterday', 'last24h', 'last7days', 'older'];
  static const _sectionLabels = {
    'yesterday': 'YESTERDAY',
    'last24h': 'LAST 24 HRS',
    'last7days': 'LAST 7 DAYS',
    'older': 'OLDER',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tabIndex == 2) {
      return const _FollowRequestsTab();
    }

    final allItems = ref.watch(activityTabFeedProvider);
    final key = _tabKeys[tabIndex];
    final items = allItems.where((e) {
      final tabs = (e['forTabs'] as List).cast<String>();
      return tabs.contains(key);
    }).toList();

    final bySection = <String, List<Map<String, dynamic>>>{};
    for (final e in items) {
      final s = e['section'] as String? ?? 'older';
      bySection.putIfAbsent(s, () => []).add(e);
    }

    final bottomPad = MediaQuery.paddingOf(context).bottom + 100;
    final slivers = <Widget>[];
    var firstSection = true;
    for (final sec in _sectionOrder) {
      final group = bySection[sec];
      if (group == null || group.isEmpty) continue;
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, firstSection ? 12 : 20, 16, 8),
            child: Text(
              _sectionLabels[sec]!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.9,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
      );
      firstSection = false;
      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ActivityFeedRow(data: group[index]),
            childCount: group.length,
          ),
        ),
      );
    }

    slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 16)));
    slivers.add(SliverToBoxAdapter(child: _DiscoveryCard(bottomPad: bottomPad)));

    return ColoredBox(
      color: _feedCanvas,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: slivers,
      ),
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({required this.bottomPad});

  final double bottomPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPad),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DISCOVERY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'New Curations In Your Network',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (var i = 0; i < 3; i++)
                  Align(
                    widthFactor: i == 0 ? 1 : 0.72,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          [
                            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=120&q=80',
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=120&q=80',
                            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=120&q=80',
                          ][i],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 40,
                            height: 40,
                            color: AppColors.border,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                const Text(
                  '+12',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FollowRequestsTab extends ConsumerWidget {
  const _FollowRequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(followRequestsInboxProvider);
    final suggested = ref.watch(followListUsersProvider);
    final bottomPad = MediaQuery.paddingOf(context).bottom + 24;

    return ColoredBox(
      color: AppColors.surface,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final r = requests[index];
                return _FollowRequestRow(
                  username: r['username'] as String,
                  fullName: r['fullName'] as String,
                  avatarUrl: r['avatarUrl'] as String?,
                );
              },
              childCount: requests.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'SUGGESTED FOR YOU',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: AppColors.textPrimary.withValues(alpha: 0.75),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: suggested.length.clamp(0, 8),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final u = suggested[index];
                  return _SuggestedUserCard(
                    username: u['username'] as String,
                    fullName: u['displayName'] as String,
                    avatarUrl: u['avatarUrl'] as String?,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: bottomPad)),
        ],
      ),
    );
  }
}

class _FollowRequestRow extends StatelessWidget {
  const _FollowRequestRow({
    required this.username,
    required this.fullName,
    this.avatarUrl,
  });

  final String username;
  final String fullName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final handle = username.replaceFirst('@', '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/profile/u/$handle'),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  ClipOval(
                    child: avatarUrl != null
                        ? Image.network(
                            avatarUrl!,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _avatarFallback(),
                          )
                        : _avatarFallback(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.authFlowPrimary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'APPROVE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: AppColors.background,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.xmark,
                size: 16,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      width: 52,
      height: 52,
      color: AppColors.background,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.person_fill, color: AppColors.textMuted),
    );
  }
}

class _SuggestedUserCard extends StatelessWidget {
  const _SuggestedUserCard({
    required this.username,
    required this.fullName,
    this.avatarUrl,
  });

  final String username;
  final String fullName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final handle = username.replaceFirst('@', '');

    return Container(
      width: 132,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/profile/u/$handle'),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: avatarUrl != null
                        ? Image.network(
                            avatarUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _ph(),
                          )
                        : _ph(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.authFlowPrimary,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'FOLLOW',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ph() {
    return Container(
      width: 56,
      height: 56,
      color: AppColors.surface,
      alignment: Alignment.center,
      child: const Icon(CupertinoIcons.person_fill, color: AppColors.textMuted, size: 22),
    );
  }
}
