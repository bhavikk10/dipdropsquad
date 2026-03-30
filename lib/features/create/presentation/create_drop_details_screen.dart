import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/cupertino/app_header_bar.dart';
import 'widgets/drop_setting_row.dart';

/// Caption + settings after picking media for a new drop.
class CreateDropDetailsScreen extends StatefulWidget {
  const CreateDropDetailsScreen({super.key});

  @override
  State<CreateDropDetailsScreen> createState() => _CreateDropDetailsScreenState();
}

class _CreateDropDetailsScreenState extends State<CreateDropDetailsScreen> {
  final _captionController = TextEditingController();
  bool _exclusiveDrop = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          AppHeaderBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () => context.pop(),
              child: const Icon(CupertinoIcons.back, color: AppColors.textPrimary, size: 28),
            ),
            middle: const Text(
              'New Drop',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () {},
              child: const Text(
                'Share',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: CupertinoTextField(
                          controller: _captionController,
                          placeholder: 'Write a caption...',
                          maxLines: 4,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                          placeholderStyle: const TextStyle(color: AppColors.textMuted),
                          decoration: const BoxDecoration(color: Color(0x00000000)),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: AppColors.border),
              DropSettingRow(
                'Add to collection',
                showBottomBorder: true,
              ),
              DropSettingRow(
                'Add location',
                showBottomBorder: true,
              ),
              DropSettingRow(
                'Exclusive Drop',
                isSwitch: true,
                switchValue: _exclusiveDrop,
                onChanged: (v) => setState(() => _exclusiveDrop = v),
                showBottomBorder: true,
              ),
              const DropSettingRow('Advanced settings'),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    ),
        ],
      ),
    );
  }
}
