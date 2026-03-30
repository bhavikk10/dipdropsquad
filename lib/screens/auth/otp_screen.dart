import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/auth/auth_widgets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  String _otp = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onOtpChanged(String v) {
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    final trimmed = digits.length > 4 ? digits.substring(0, 4) : digits;
    setState(() {
      _otp = trimmed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final boxes = List.generate(4, (i) {
      final char = i < _otp.length ? _otp[i] : '';
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            char,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w900,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.chevron_left,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'VERIFY IDENTITY',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                'We sent a 4-digit code to your phone ending in ****84.',
                style: GoogleFonts.inter(
                  color: const Color(0xFF777777),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: boxes
                    .map((w) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: w,
                        ))
                    .toList(),
              ),
            ),

            // Hidden field to capture OTP digits.
            SizedBox(
              height: 0,
              width: 0,
              child: TextField(
                controller: _otpController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                maxLength: 4,
                onChanged: _onOtpChanged,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Resend code in 00:30',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF777777),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Spacer(),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: NeonPillButton(
                  text: 'Verify & Continue',
                  onPressed: () {
                    context.push('/auth/terms');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

