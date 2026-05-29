import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/cyber_gradient_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  int _age = 18;

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.go(AppRoutes.privacyConsent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.go(AppRoutes.onboarding),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Join FocusShield',
                    style: CyberTypography.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reclaim your time and boost your daily focus score with secure, on-device AI tracking.',
                    style: CyberTypography.bodyMedium.copyWith(
                      color: CyberColors.onSurfaceVariant,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form fields — flat matte container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: CyberColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.04),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Username'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _usernameController,
                          style: CyberTypography.bodyLarge.copyWith(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'e.g. arjuna_focus',
                            prefixIcon: Icon(Icons.alternate_email_rounded,
                                color: CyberColors.onSurfaceMuted),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Please enter a username' : null,
                        ),
                        const SizedBox(height: 18),

                        _buildFieldLabel('Display Name'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _displayNameController,
                          style: CyberTypography.bodyLarge.copyWith(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'e.g. Arjuna Dev',
                            prefixIcon: Icon(Icons.person_outline_rounded,
                                color: CyberColors.onSurfaceMuted),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Please enter a display name' : null,
                        ),
                        const SizedBox(height: 18),

                        _buildFieldLabel('Email Address (Optional)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: CyberTypography.bodyLarge.copyWith(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'e.g. hello@focusshield.com',
                            prefixIcon: Icon(Icons.mail_outline_rounded,
                                color: CyberColors.onSurfaceMuted),
                          ),
                        ),
                        const SizedBox(height: 18),

                        _buildFieldLabel('Phone Number'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: CyberTypography.bodyLarge.copyWith(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'e.g. +91 98765 43210',
                            prefixIcon: Icon(Icons.phone_outlined,
                                color: CyberColors.onSurfaceMuted),
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Please enter a phone number' : null,
                        ),
                        const SizedBox(height: 20),

                        // Age selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Age',
                              style: CyberTypography.labelLarge.copyWith(
                                color: CyberColors.onSurfaceVariant,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: CyberColors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.06),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _ageButton(
                                    icon: Icons.remove_rounded,
                                    onPressed: () {
                                      if (_age > 5) setState(() => _age--);
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 14),
                                    child: Text(
                                      '$_age',
                                      style: CyberTypography.titleMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  _ageButton(
                                    icon: Icons.add_rounded,
                                    onPressed: () {
                                      if (_age < 120) setState(() => _age++);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  CyberGradientButton(
                    label: 'Create Account',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _submit,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: CyberTypography.labelLarge.copyWith(
        color: CyberColors.onSurfaceVariant,
      ),
    );
  }

  Widget _ageButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: CyberColors.onSurfaceVariant, size: 20),
        ),
      ),
    );
  }
}
