import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/providers/qr_provider.dart';
import 'package:qr21/widgets/qr_widget.dart';

class QrDataWidget extends StatelessWidget {
  const QrDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final qrprov = Provider.of<QrProvider>(context);
    return Center(
      child: qrprov.data == null
          ? FCircularProgress(size: .xl)
          : _QrDataWidgetImpl(data: qrprov.data!),
    );
  }
}

class _QrDataWidgetImpl extends StatelessWidget {
  final QrData data;
  const _QrDataWidgetImpl({required this.data});

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;
    final colors = context.theme.colors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QrWidget(data: data.src),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.username,
              style: typography.body.md.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              _format_expires_date(data.expires),
              style: () {
                if (_is_expired(data.expires)) {
                  return typography.body.md.copyWith(
                    color: colors.destructive,
                  );
                }
                return null;
              }(),
            ),
          ],
        ),
      ],
    );
  }
}

String _format_expires_date(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return "$day.$month.${date.year}";
}

bool _is_expired(DateTime date) {
  var now = DateTime.now();
  now = DateTime(now.year, now.month, now.day);
  return !now.isBefore(date);
}
