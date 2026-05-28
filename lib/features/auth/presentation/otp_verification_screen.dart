import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_gradient_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onDigitInput(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  bool _isCodeComplete() {
    return _controllers.every((c) => c.text.isNotEmpty);
  }

  void _verifyCode() {
    if (_isCodeComplete()) {
      context.go(AppRoutes.permissionSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Verification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.go(AppRoutes.privacyConsent),
        ),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify Phone Number',
                  style: CyberTypography.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We have sent a verification code to your device at ${widget.phoneNumber.isNotEmpty ? widget.phoneNumber : "+91 98765 43210"}. Please enter the 6-digit code below.',
                  style: CyberTypography.bodyMedium.copyWith(
                    color: CyberColors.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 40),

                // 6-digit OTP inputs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) {
                      final isFilled = _controllers[index].text.isNotEmpty;
                      return SizedBox(
                        width: 48,
                        height: 58,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (val) => _onDigitInput(val, index),
                          style: CyberTypography.headlineSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            fillColor: CyberColors.surfaceContainer,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                // Filled slot: green border; empty: subtle
                                color: isFilled
                                    ? CyberColors.neonGreen.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.08),
                                width: isFilled ? 1.5 : 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: CyberColors.electricBlue,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Resend code — blue text, no cyan
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh_rounded, size: 17),
                    label: Text(
                      'Resend Verification Code',
                      style: CyberTypography.labelLarge.copyWith(
                        color: CyberColors.electricBlue,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                CyberGradientButton(
                  label: 'Verify & Continue',
                  icon: Icons.verified_rounded,
                  onPressed: _isCodeComplete() ? _verifyCode : null,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
