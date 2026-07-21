import "package:auto_image/auto_image.dart";
import "package:flutter/material.dart";
import "package:forui/forui.dart";
import "package:provider/provider.dart";
import "package:qr21/router.dart";
import "package:device_screen_brightness/device_screen_brightness.dart";

class QrWidget extends StatefulWidget {
  final String data;

  const QrWidget({super.key, required this.data});

  @override
  State<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> with RouteAware {
  late Qr21RouteObserver _route_observer;

  @override
  void didPop() {
    _reset_br();
  }

  @override
  void didPushNext() {
    _reset_br();
  }

  @override
  void didPush() {
    _set_br(100);
  }

  @override
  void didPopNext() {
    _set_br(100);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final FBorderRadius bradius = theme.style.borderRadius;
    return LayoutBuilder(
      builder: (context, constraints) {
        final extent = constraints.maxWidth;
        return SizedBox(
          width: extent,
          height: extent,
          child: AutoImage(
            this.widget.data,
            width: extent,
            fit: BoxFit.fitWidth,
            shape: ImageShape.roundedRect,
            borderRadius: bradius.lg,
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _route_observer = Provider.of<Qr21RouteObserver>(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _route_observer.subscribe(this, ModalRoute.of(context) as PageRoute);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _route_observer.unsubscribe(this);
  }
}

void _set_br(int value) {
  DeviceScreenBrightness.setBrightness(
    value,
    mode: BrightnessMode.app,
  );
}

void _reset_br() {
  DeviceScreenBrightness.setBrightness(
    DeviceScreenBrightness.getBrightness(),
    mode: BrightnessMode.app,
  );
}
