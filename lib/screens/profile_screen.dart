import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';
import '../providers/mock_data_provider.dart';
import '../providers/mock_providers.dart';
import '../theme/theme_provider.dart';
import '../widgets/cupertino/main_app_header.dart';
import '../widgets/drop_card.dart';

String _normHandle(String? raw) {
  if (raw == null || raw.isEmpty) return 'alex_drops';
  return raw.toLowerCase().replaceAll('@', '');
}

String _fmtCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
  return '$n';
}

/// Tab profile (`viewedHandle == null` or `alex_drops`) vs another user (`/profile/u/:handle`).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.viewedHandle});

  /// Feed username without `@`, e.g. `elenav_studio`.
  final String? viewedHandle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dips = ref.watch(dipsProvider);
    final allDrops = ref.watch(dropsProvider);
    final me = ref.watch(userProfileProvider);
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final handleKey = _normHandle(viewedHandle);
    final isSelf = viewedHandle == null || handleKey == 'alex_drops';
    final inboxChatId = ref.watch(chatThreadIdByHandleProvider(handleKey));

    final UserProfile? other =
        isSelf ? null : ref.watch(profileByHandleProvider(handleKey));
    if (!isSelf && other == null) {
      return Scaffold(
        backgroundColor: cs.background,
        body: Column(
          children: [
            const MainAppHeader(showLeadingBack: true),
            Expanded(
              child: Center(
                child: Text('Profile not found', style: TextStyle(color: cs.onSurfaceVariant)),
              ),
            ),
          ],
        ),
      );
    }

    final UserProfile profile = isSelf ? me : other!;
    final userDips = dips.where((d) => d.username.toLowerCase() == handleKey).toList();
    final userDrops = allDrops.where((d) => d.sellerHandle.toLowerCase() == handleKey).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.background,
        body: Column(
          children: [
            MainAppHeader(
              showEditProfile: isSelf,
              showLeadingBack: !isSelf,
              onTitleLongPress: () {
                final current = ref.read(themeModeProvider);
                ref.read(themeModeProvider.notifier).state =
                    current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
              },
            ),
            Expanded(
              child: NestedScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            image: DecorationImage(
                              image: NetworkImage(profile.avatarUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          right: -4,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: cs.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.displayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.onBackground,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.username.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Text(
                        profile.bio,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!isSelf)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: inboxChatId != null ? 3 : 1,
                              child: Material(
                                color: cs.primary,
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        profile.isFollowing ? 'Following' : 'Follow',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (inboxChatId != null) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: Material(
                                  color: cs.surfaceVariant,
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                    onTap: () =>
                                        context.push('/chat/room/$inboxChatId'),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: isLight
                                            ? Border.all(color: cs.outlineVariant, width: 1)
                                            : null,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.paperplane_fill,
                                        color: cs.onBackground,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    if (!isSelf) const SizedBox(height: 24),
                    if (isSelf)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: CupertinoButton(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(16),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            onPressed: () => context.push('/profile/dropper'),
                            child: const Text(
                              'Become a Dropper',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (isSelf) const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: isLight ? Border.all(color: cs.outlineVariant, width: 1) : null,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatBlock(
                              value: _fmtCount(profile.followers),
                              label: 'FOLLOWERS',
                              onTap: () => context.push(
                                Uri(
                                  path: '/profile/connections',
                                  queryParameters: {
                                    'handle': handleKey,
                                    'name': profile.displayName,
                                    'tab': '0',
                                  },
                                ).toString(),
                              ),
                            ),
                            VerticalDivider(
                              color: cs.onSurface.withOpacity(0.15),
                              thickness: 1,
                              width: 32,
                            ),
                            _StatBlock(
                              value: _fmtCount(profile.following),
                              label: 'FOLLOWING',
                              onTap: () => context.push(
                                Uri(
                                  path: '/profile/connections',
                                  queryParameters: {
                                    'handle': handleKey,
                                    'name': profile.displayName,
                                    'tab': '1',
                                  },
                                ).toString(),
                              ),
                            ),
                            VerticalDivider(
                              color: cs.onSurface.withOpacity(0.15),
                              thickness: 1,
                              width: 32,
                            ),
                            _StatBlock(value: '${profile.dropsCount}', label: 'DROPS'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: const EdgeInsets.only(left: 16),
                    dividerColor: Colors.transparent,
                    indicatorColor: cs.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3.0,
                    labelColor: cs.onBackground,
                    unselectedLabelColor: cs.onSurfaceVariant,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    tabs: const [
                      Tab(text: 'Dips'),
                      Tab(text: 'Drops'),
                    ],
                  ),
                  cs.background,
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              userDips.isEmpty
                  ? ListView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.only(top: 48, bottom: 120),
                      children: [
                        Center(
                          child: Text('No dips yet', style: TextStyle(color: cs.onSurfaceVariant)),
                        ),
                      ],
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: userDips.length,
                      itemBuilder: (context, index) {
                        final dip = userDips[index];
                        final likeText = dip.likes >= 1000
                            ? '${(dip.likes / 1000).toStringAsFixed(1)}k'
                            : '${dip.likes}';
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(dip.mediaUrl, fit: BoxFit.cover),
                              const Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0x00000000),
                                        Color(0xCC000000),
                                      ],
                                      stops: [0.55, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 12,
                                child: Row(
                                  children: [
                                    const Icon(CupertinoIcons.heart_fill, color: Colors.white, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      likeText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              userDrops.isEmpty
                  ? ListView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.only(top: 48, bottom: 120),
                      children: [
                        Center(
                          child: Text('No drops listed', style: TextStyle(color: cs.onSurfaceVariant)),
                        ),
                      ],
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.55,
                      ),
                      itemCount: userDrops.length,
                      itemBuilder: (context, index) {
                        final offsetTop = index.isOdd ? 40.0 : 0.0;
                        return Transform.translate(
                          offset: Offset(0, offsetTop),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: DropCard(drop: userDrops[index]),
                          ),
                        );
                      },
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _SliverAppBarDelegate(this.tabBar, this.backgroundColor);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _StatBlock({required this.value, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: cs.onBackground,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: cs.onSurfaceVariant,
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
    if (onTap == null) return column;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: column,
        ),
      ),
    );
  }
}
