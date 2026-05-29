import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';

/// Arjuna AI Coach — calm, conversational chat interface.
/// Inspired by Telegram / iMessage: flat bubbles, clean layout.
class ArjunaChatScreen extends StatefulWidget {
  const ArjunaChatScreen({super.key});

  @override
  State<ArjunaChatScreen> createState() => _ArjunaChatScreenState();
}

class _ArjunaChatScreenState extends State<ArjunaChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: "Hey! I'm Arjuna, your AI focus coach. I've been watching your usage patterns today.",
      isUser: false,
    ),
    const _ChatMessage(
      text: "Your focus score is at 87 — really strong. You've kept Instagram under 45 min today.",
      isUser: false,
    ),
    const _ChatMessage(
      text: 'Thanks Arjuna! Any tips for staying focused this afternoon?',
      isUser: true,
    ),
    const _ChatMessage(
      text: "Based on your patterns, you tend to check social media most between 2–4 PM. Try a 25-min Deep Focus block before lunch — it sets the tone for the afternoon.",
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
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Compact AI avatar — no glow ring
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CyberColors.neonGreen.withOpacity(0.10),
                border: Border.all(
                  color: CyberColors.neonGreen.withOpacity(0.18),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: CyberColors.neonGreen,
                size: 14,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              'Arjuna',
              style: CyberTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 7),
            // Online dot — no glow
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CyberColors.neonGreen,
                // No boxShadow
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Messages ──────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _ChatBubble(message: _messages[index]);
                },
              ),
            ),

            // ── Input bar — minimal glass, low blur ───────────────
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                  decoration: BoxDecoration(
                    color: CyberColors.surface.withOpacity(0.92),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: CyberColors.surfaceBright,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                            ),
                          ),
                          child: TextField(
                            controller: _controller,
                            style: CyberTypography.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ask Arjuna...',
                              hintStyle: CyberTypography.bodyMedium.copyWith(
                                color: CyberColors.onSurfaceMuted,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 11,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      // Send button — flat solid green, no gradient, no glow
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: CyberColors.neonGreen,
                            // No boxShadow
                          ),
                          child: const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                            size: 19,
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
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI avatar — compact, no glow
          if (!message.isUser) ...[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CyberColors.neonGreen.withOpacity(0.10),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: CyberColors.neonGreen,
                size: 12,
              ),
            ),
            const SizedBox(width: 7),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                // User: proper dark blue — not a translucent overlay
                // AI: dark surface
                color: message.isUser
                    ? const Color(0xFF1E3A5F) // deep navy blue
                    : CyberColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
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
          if (message.isUser) const SizedBox(width: 6),
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
