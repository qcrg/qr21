import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AppCredsWidget extends StatelessWidget {
  final Widget child;

  const AppCredsWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    return Stack(
      children: [
        child,
        Positioned(
          right: 0,
          bottom: 0,
          child: Text(
            "qcrg [s21:sethbowm]",
            style: TextStyle(
              color: colors.foreground.withValues(alpha: 0.1),
            ),
          ),
        ),
      ],
    );
  }
}
