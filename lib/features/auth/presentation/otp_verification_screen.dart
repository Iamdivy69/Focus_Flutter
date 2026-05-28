import 'package:flutter/material.dart';

/// Placeholder — full implementation in Phase 1, Prompt 5.
class OtpVerificationScreen extends StatelessWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone')),
      body: Center(
        child: Text('OTP Verification — $phoneNumber — Phase 1'),
      ),
    );
  }
}
