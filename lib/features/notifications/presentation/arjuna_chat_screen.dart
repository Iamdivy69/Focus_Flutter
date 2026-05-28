import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';

/// Arjuna AI Coach chat screen.
class ArjunaChatScreen extends StatefulWidget {
  const ArjunaChatScreen({super.key});

  @override
  State<ArjunaChatScreen> createState() => _ArjunaChatScreenState();
}

class _ArjunaChatScreenState extends State<ArjunaChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Hey there! 👋 I\'m Arjuna, your AI focus coach. I\'ve been analyzing your usage patterns today.',
      isUser: false,
    ),
    _ChatMessage(
      text: 'Your focus score is looking strong at 87! You\'ve been great about limiting Instagram today.',
      isUser: false,
    ),
    _ChatMessage(
      text: 'Thanks Arjuna! Any tips for staying focused this afternoon?',
      isUser: true,
    ),
    _ChatMessage(
      text: 'Great question! Based on your patterns, you tend to check social media most between 2-4 PM. Try setting a 25-min Deep Focus session before lunch — it\'ll set the momentum for the afternoon! 🎯',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: _controller.text.trim(), isUser: true));
      _controller.clear();
    });
    // Auto-scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CyberColors.neonGreen.withOpacity(0.15),
                border: Border.all(color: CyberColors.neonGreen.withOpacity(0.3)),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: CyberColors.neonGreen, size: 16),
            ),
            const SizedBox(width: 10),
            Text('Arjuna', style: CyberTypography.titleLarge.copyWith(color: Colors.white, fontSize: 18)),
            const SizedBox(width: 6),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CyberColors.neonGreen,
                boxShadow: [BoxShadow(color: CyberColors.neonGreen.withOpacity(0.5), blurRadius: 6)],
              ),
            ),
          ],
        ),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Chat messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _ChatBubble(message: msg);
                  },
                ),
              ),

              // Input bar
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      color: CyberColors.surfaceContainer.withOpacity(0.7),
                      border: Border(
                        top: BorderSide(color: CyberColors.outlineVariant.withOpacity(0.3)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: CyberColors.surfaceContainerHigh.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: CyberColors.outlineVariant),
                            ),
                            child: TextField(
                              controller: _controller,
                              style: CyberTypography.bodyMedium.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Ask Arjuna...',
                                hintStyle: CyberTypography.bodyMedium.copyWith(color: CyberColors.onSurfaceMuted),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: CyberColors.buttonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: CyberColors.neonGreen.withOpacity(0.3),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: CyberColors.onNeonGreen,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CyberColors.neonGreen.withOpacity(0.12),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: CyberColors.neonGreen, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? CyberColors.electricBlue.withOpacity(0.2)
                    : CyberColors.surfaceContainerHigh.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 20),
                ),
                border: Border.all(
                  color: message.isUser
                      ? CyberColors.electricBlue.withOpacity(0.2)
                      : CyberColors.neonGreen.withOpacity(0.08),
                ),
              ),
              child: Text(
                message.text,
                style: CyberTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  const _ChatMessage({required this.text, required this.isUser});
}
