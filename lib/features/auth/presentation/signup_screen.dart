import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import 'widgets/auth_brand_app_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _step = 0;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _about = TextEditingController();
  final _location = TextEditingController();

  DateTime? _dob;
  bool _obscurePassword = true;

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()
      ..onTap = () {
        if (mounted) context.push('/auth/terms');
      };
    _privacyTap = TapGestureRecognizer()..onTap = () {};
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _username.dispose();
    _password.dispose();
    _about.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.authFlowPrimary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dob = picked);
  }

  InputDecoration _decoration(String hint, {Widget? prefix, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 15),
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.onboardingFieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _onBack() {
    if (_step > 0) {
      setState(() => _step = 0);
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/auth/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AuthBrandAppBar(onLeading: _onBack),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _step == 0
              ? KeyedSubtree(
                  key: const ValueKey(0),
                  child: _JoinSquadStep(
                    firstName: _firstName,
                    lastName: _lastName,
                    email: _email,
                    phone: _phone,
                    username: _username,
                    password: _password,
                    dob: _dob,
                    obscurePassword: _obscurePassword,
                    onTogglePassword: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    onPickDob: _pickDob,
                    decoration: _decoration,
                    termsTap: _termsTap,
                    privacyTap: _privacyTap,
                    onContinue: () => setState(() => _step = 1),
                  ),
                )
              : KeyedSubtree(
                  key: const ValueKey(1),
                  child: _SetVibeStep(
                    about: _about,
                    location: _location,
                    decoration: _decoration,
                    onFinish: () => context.push('/auth/verify'),
                  ),
                ),
        ),
      ),
    );
  }
}

class _JoinSquadStep extends StatelessWidget {
  const _JoinSquadStep({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.dob,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onPickDob,
    required this.decoration,
    required this.termsTap,
    required this.privacyTap,
    required this.onContinue,
  });

  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController username;
  final TextEditingController password;
  final DateTime? dob;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onPickDob;
  final InputDecoration Function(String hint, {Widget? prefix, Widget? suffix}) decoration;
  final TapGestureRecognizer termsTap;
  final TapGestureRecognizer privacyTap;
  final VoidCallback onContinue;

  String get _dobLabel {
    if (dob == null) return 'MM / DD / YYYY';
    final d = dob!;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$m / $day / ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 1.05,
                color: AppColors.textPrimary,
              ),
              children: [
                const TextSpan(text: 'JOIN THE\n'),
                TextSpan(
                  text: 'SQUAD',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brandPeriwinkle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Enter your details below to secure your spot in the elite training network.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.45,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('FIRST NAME'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: firstName,
                      style: GoogleFonts.inter(fontSize: 15),
                      decoration: decoration('Alex'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('LAST NAME'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: lastName,
                      style: GoogleFonts.inter(fontSize: 15),
                      decoration: decoration('Rivera'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _label('EMAIL'),
          const SizedBox(height: 8),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.inter(fontSize: 15),
            decoration: decoration('you@example.com'),
          ),
          const SizedBox(height: 18),
          _label('PHONE NUMBER'),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.onboardingFieldFill,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '+1',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.inter(fontSize: 15),
                  decoration: decoration('555 000 0000'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _label('DATE OF BIRTH'),
          const SizedBox(height: 8),
          Material(
            color: AppColors.onboardingFieldFill,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: onPickDob,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dobLabel,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: dob == null ? AppColors.textMuted : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _label('USERNAME'),
          const SizedBox(height: 8),
          TextField(
            controller: username,
            style: GoogleFonts.inter(fontSize: 15),
            decoration: decoration(
              'username',
              prefix: Padding(
                padding: const EdgeInsets.only(left: 12, right: 4),
                child: Text(
                  '@',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _label('PASSWORD'),
          const SizedBox(height: 8),
          TextField(
            controller: password,
            obscureText: obscurePassword,
            style: GoogleFonts.inter(fontSize: 15),
            decoration: decoration(
              '••••••••',
              suffix: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.textMuted,
                ),
                onPressed: onTogglePassword,
              ),
            ),
          ),
          const SizedBox(height: 28),
          _GradientContinueButton(
            label: 'CONTINUE',
            onPressed: onContinue,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.textMuted,
                ),
                children: [
                  const TextSpan(text: 'By continuing, you agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: termsTap,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: privacyTap,
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.secureEnrollmentSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.authFlowPrimary.withValues(alpha: 0.12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield_outlined, color: AppColors.authFlowPrimary, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SECURE ENROLLMENT',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your data is encrypted and never shared with third parties.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'STEP 1 OF 3',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) {
    return Text(
      t,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: AppColors.textMuted,
      ),
    );
  }
}

class _GradientContinueButton extends StatelessWidget {
  const _GradientContinueButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.joinGradientStart, AppColors.joinGradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.joinGradientStart.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SetVibeStep extends StatelessWidget {
  const _SetVibeStep({
    required this.about,
    required this.location,
    required this.decoration,
    required this.onFinish,
  });

  final TextEditingController about;
  final TextEditingController location;
  final InputDecoration Function(String hint, {Widget? prefix, Widget? suffix}) decoration;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'SET YOUR VIBE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Define your digital presence in the squad.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      Material(
                        color: AppColors.onboardingFieldFill,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {},
                          child: SizedBox(
                            width: 112,
                            height: 112,
                            child: Icon(Icons.add, size: 36, color: AppColors.textMuted),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'UPLOAD PROFILE PICTURE',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: AppColors.authFlowPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'ABOUT YOU',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: about,
                  maxLines: 4,
                  style: GoogleFonts.inter(fontSize: 15),
                  decoration: decoration('Tell the squad who you are...'),
                ),
                const SizedBox(height: 18),
                Text(
                  'CURRENT BASE (OPTIONAL)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: location,
                  style: GoogleFonts.inter(fontSize: 15),
                  decoration: decoration(
                    'City, Country',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 22),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: onFinish,
                        style: FilledButton.styleFrom(
                      backgroundColor: AppColors.authFlowPrimary,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: AppColors.authFlowPrimary.withValues(alpha: 0.4),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'FINISH SETUP',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'STEP 3 OF 3 • ALMOST THERE',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
