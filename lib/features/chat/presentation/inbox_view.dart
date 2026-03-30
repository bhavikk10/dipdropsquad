import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/mock_providers.dart';
import '../../../theme/app_colors.dart';
import 'widgets/inbox_tile.dart';

/// Body-only inbox list (no page chrome).
class InboxView extends ConsumerWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threads = ref.watch(inboxThreadsProvider);
    final bottomPad = MediaQuery.paddingOf(context).bottom + 88;

    return Container(
      color: AppColors.background,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.only(bottom: bottomPad),
        itemCount: threads.length,
        itemBuilder: (context, index) {
          final thread = threads[index];
          final chatId = thread['id'] as String? ?? 'd1';
          final username = thread['username'] as String? ?? '';
          final handle = username.replaceFirst('@', '');
          return InboxTile(
            thread: thread,
            onPressed: () => context.push('/chat/room/$chatId'),
            onProfilePressed: handle.isEmpty
                ? null
                : () => context.push('/profile/u/$handle'),
          );
        },
      ),
    );
  }
}
