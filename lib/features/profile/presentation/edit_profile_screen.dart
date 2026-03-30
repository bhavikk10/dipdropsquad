import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/mock_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/cupertino/app_header_bar.dart';
import '../../../widgets/cupertino/custom_cupertino_input.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _username;
  late final TextEditingController _bio;
  late final TextEditingController _link;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _username = TextEditingController();
    _bio = TextEditingController();
    _link = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _seeded) return;
      _seeded = true;
      final d = ref.read(editProfileProvider);
      _name.text = d['name'] as String;
      _username.text = d['username'] as String;
      _bio.text = d['bio'] as String;
      _link.text = d['link'] as String;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _bio.dispose();
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(editProfileProvider);
    final avatarUrl = data['avatarUrl'] as String;
    final email = data['email'] as String;
    final phone = data['phone'] as String;
    final gender = data['gender'] as String;

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          AppHeaderBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.pop(),
              child: const Icon(CupertinoIcons.back, color: AppColors.textPrimary, size: 28),
            ),
            middle: const Text(
              'EDIT PROFILE',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.pop(),
              child: const Text(
                'SAVE',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(avatarUrl),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: AppColors.border, width: 1),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF000000).withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFFFFFF), width: 1.5),
                          ),
                          child: const Icon(
                            CupertinoIcons.camera_fill,
                            color: Color(0xFFFFFFFF),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: const Text(
                        'Change Profile Photo',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              CustomCupertinoInput(
                label: 'Name',
                placeholder: 'Name',
                controller: _name,
              ),
              const SizedBox(height: 24),
              CustomCupertinoInput(
                label: 'Username',
                placeholder: 'Username',
                controller: _username,
              ),
              const SizedBox(height: 24),
              CustomCupertinoInput(
                label: 'Bio',
                placeholder: 'Bio',
                maxLines: 4,
                controller: _bio,
              ),
              const SizedBox(height: 24),
              CustomCupertinoInput(
                label: 'Link',
                placeholder: 'Link',
                controller: _link,
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 12, right: 4),
                  child: Icon(CupertinoIcons.link, color: AppColors.textMuted, size: 20),
                ),
              ),
              const SizedBox(height: 32),
              Container(height: 1, color: AppColors.border),
              const SizedBox(height: 20),
              CupertinoButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                onPressed: () {},
                child: const Text(
                  'Switch to Professional Account',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'PRIVATE INFORMATION',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 12),
              _privateRow('Email', email),
              _privateRow('Phone', phone),
              _privateRow('Gender', gender),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
        ],
      ),
    );
  }

  Widget _privateRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
