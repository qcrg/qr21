import 'package:flutter/material.dart';
import 'package:qr21/widgets/qr_data_widget.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrDataWidget(),
    );
  }
}
