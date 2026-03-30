import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/mock_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../widgets/cupertino/app_header_bar.dart';

/// Cupertino-only squad chat (no Material scaffold).
class ChatScreen extends ConsumerWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(dropDetailProvider);
    final thread = ref.watch(chatThreadByIdProvider(chatId));
    final messages = ref.watch(chatMessagesForThreadProvider(chatId));
    final chatName = (thread?['displayName'] as String?) ?? 'Chat';
    final chatHandle = thread?['username'] as String?;
    final chatAvatar = thread?['avatarUrl'] as String?;
    final title = (detail['title'] as String).toUpperCase();
    final subtitle = (detail['subtitle'] as String).toUpperCase();
    final price = (detail['price'] as num).toDouble();
    final thumb = (detail['images'] as List).cast<String>().first;

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeaderBar(
            leadingWidth: 48,
            middleAlignment: Alignment.centerLeft,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.pop(),
              child: const Icon(AppIcons.backChevron, color: AppColors.textPrimary, size: 28),
            ),
            middle: GestureDetector(
              onTap: () {
                if (chatHandle != null && chatHandle.isNotEmpty) {
                  final handle = chatHandle.replaceFirst('@', '');
                  context.push('/profile/u/$handle');
                }
              },
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    if (chatAvatar != null)
                      ClipOval(
                        child: Image.network(
                          chatAvatar,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            AppIcons.person,
                            size: 22,
                            color: AppColors.textMuted,
                          ),
                        ),
                      )
                    else
                      const Icon(AppIcons.person, size: 26, color: AppColors.textMuted),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            chatName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (chatHandle != null)
                            Text(
                              chatHandle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
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
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: const Icon(AppIcons.more, color: AppColors.textPrimary, size: 26),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      thumb,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 40,
                        height: 40,
                        color: AppColors.chatReceiverBg,
                        child: const Icon(AppIcons.photo, size: 18, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$title: $subtitle',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              width: 4,
                              height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Text(
                              'Squad Buy Active',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    color: AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(100),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    onPressed: () {},
                    child: const Text(
                      'VIEW',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[messages.length - 1 - index];
                  return _ChatBubbleRow(msg: msg);
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Container(
                color: AppColors.background,
                padding: const EdgeInsets.all(16),
                child: CupertinoTextField(
                  placeholder: 'Message...',
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.chatReceiverBg,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      AppIcons.send,
                      color: AppColors.accent,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubbleRow extends StatelessWidget {
  const _ChatBubbleRow({required this.msg});

  final Map<String, dynamic> msg;

  /// Square attachment with iOS-style heavy rounding (squircle-like silhouette).
  static const double _imageSide = 216;
  static const double _imageCornerRadius = 48;

  @override
  Widget build(BuildContext context) {
    final isMe = msg['isMe'] as bool;
    final text = msg['text'] as String? ?? '';
    final ts = msg['timestamp'] as String?;
    final avatarUrl = msg['avatarUrl'] as String?;
    final senderId = msg['senderId'] as String;
    final imageUrl = msg['imageUrl'] as String?;

    final label = isMe ? 'YOU' : senderId.toUpperCase();

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? AppColors.chatSenderBg : AppColors.chatReceiverBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageUrl != null) ...[
            SizedBox(
              width: _imageSide,
              height: _imageSide,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_imageCornerRadius),
                child: Image.network(
                  imageUrl,
                  width: _imageSide,
                  height: _imageSide,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: _imageSide,
                    height: _imageSide,
                    color: AppColors.chatReceiverBg,
                    alignment: Alignment.center,
                    child: const Icon(
                      AppIcons.photo,
                      size: 32,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
            if (text.isNotEmpty) const SizedBox(height: 8),
          ],
          if (text.isNotEmpty)
            Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                height: 1.35,
              ),
            ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && avatarUrl != null) ...[
            ClipOval(
              child: Image.network(
                avatarUrl,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 24,
                  height: 24,
                  color: AppColors.chatReceiverBg,
                  alignment: Alignment.center,
                  child: const Icon(AppIcons.person, size: 12, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isMe ? AppColors.accent : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                bubble,
                if (isMe && ts != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Read $ts',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
