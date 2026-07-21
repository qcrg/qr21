import 'package:flutter/material.dart';
import 'package:forui/widgets/dialog.dart';
import 'package:forui/widgets/progress.dart';

class WaitWidget extends StatelessWidget {
  final FDialogStyleDelta style;
  final Animation<double> animation;

  const WaitWidget({super.key, required this.style, required this.animation});
  @override
  Widget build(BuildContext context) {
    return FDialog(
      style: this.style,
      animation: animation,
      actions: const [],
      body: FCircularProgress(size: .xl),
    );
  }
}
