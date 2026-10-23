import 'package:flutter/material.dart';

import '../../../../core/widgets/gradient_background.dart';

/// Scrollable full-height layout for the auth screens: content at the top,
/// [footer] pinned to the bottom while there is room, 25 px side margins
/// (field width 340 on a 390 px screen).
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.children, this.footer});

  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...children,
                      const Spacer(),
                      if (footer != null) ...[
                        const SizedBox(height: 24),
                        footer!,
                        const SizedBox(height: 32),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Error line above the main button.
class FormErrorText extends StatelessWidget {
  const FormErrorText(this.message, {super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        message!,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFFEF4444), fontSize: 14),
      ),
    );
  }
}
