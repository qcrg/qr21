import 'package:chirp/chirp.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:forui_hooks/forui_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr21/data/services/qr_service/rocketchat/rocketchat_error.dart';
import 'package:qr21/data/services/qr_service/rocketchat/rocketchat_service.dart';
import 'package:qr21/l10n/app_localizations.dart';
import 'package:qr21/providers/qr_provider.dart';

final log = Chirp.root.addContext({"tag": "WDG:LOGIN:RC"});

// ignore: camel_case_types
class _const {
  static const username = kDebugMode ? "" : "";
  static const password = kDebugMode ? "" : "";
}

class RcLogin extends HookWidget {
  const RcLogin({super.key});

  @override
  Widget build(BuildContext context) {
    var rcservice = Provider.of<QrProvider>(
      context,
      listen: false,
    ).service.rocketchat;

    final form_key = useMemoized(() => GlobalKey<FormState>());
    final select_controller = useFSelectController<String>(
      value: "https://rocketchat-student.21-school.ru",
    );

    final base_url_key = useMemoized(() => GlobalKey<FormFieldState<String>>());
    final username_key = useMemoized(() => GlobalKey<FormFieldState<String>>());
    final password_key = useMemoized(() => GlobalKey<FormFieldState<String>>());

    final tr = AppLocalizations.of(context);
    if (tr == null) {
      log.wtf("Why 'translate' object is null????");
      return const Text("WFT!!!!!!! ALYAAAARM!! ZHOPA GORIT!!");
    }

    return Form(
      key: form_key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          FSelect(
            control: .managed(controller: select_controller),
            formFieldKey: base_url_key,
            items: {
              "rocketchat-student": "https://rocketchat-student.21-school.ru",
              "rocketchat-intensive-msk":
                  "https://rocketchat-intensive-msk.21-school.ru",
              "rocketchat-intensive-kzn":
                  "https://rocketchat-intensive-kzn.21-school.ru",
              //"other...": "other",
            },
            label: const Text("Base URL"),
          ),
          FTextFormField(
            control: .managed(initial: TextEditingValue(text: _const.username)),
            formFieldKey: username_key,
            label: const Text("Username"),
          ),
          FTextFormField.password(
            control: .managed(initial: TextEditingValue(text: _const.password)),
            formFieldKey: password_key,
            label: const Text("Passsword"),
          ),
          FButton(
            onPress: () => _submit(
              context,
              tr,
              form_key,
              base_url_key,
              username_key,
              password_key,
              rcservice,
            ),
            child: Text(tr.login),
          ),
        ],
      ),
    );
  }
}

String _rocketchat_err_to_string(AppLocalizations tr, RocketChatError err) {
  switch (err) {
    case RocketChatError.serverNotFound:
      return tr.serverNotFound;
    case RocketChatError.incorrectServer:
      return tr.incorrectServer;
    case RocketChatError.incorrectCredentials:
      return tr.incorrectCredentials;
    case RocketChatError.botNotFound:
      return tr.botNotFound;
    case RocketChatError.unauthorized:
      return tr.unauthorized;
    case RocketChatError.qrNotGenerated:
      return tr.qrNotGenerated;
  }
}

void _submit(
  BuildContext context,
  AppLocalizations tr,
  GlobalKey<FormState> form_key,
  GlobalKey<FormFieldState<String>> base_url_key,
  GlobalKey<FormFieldState<String>> username_key,
  GlobalKey<FormFieldState<String>> password_key,
  RocketChatQrService rcservice,
) async {
  if (form_key.currentState == null || !form_key.currentState!.validate()) {
    return;
  }

  final base_url = base_url_key.currentState?.value!;
  final username = username_key.currentState?.value!;
  final password = password_key.currentState?.value!;

  showFDialog(
    context: context,
    builder: (_, _, _) => FCircularProgress(size: .xl),
  );

  final err = await rcservice.login(
    baseUrl: base_url!,
    username: username!,
    password: password!,
  );
  if (!context.mounted) {
    if (err != null) {
      log.wtf("Not mounted", data: {"error": err});
    }
    return;
  }

  if (err != null) {
    showFToast(
      context: context,
      title: Text(tr.loginFailed),
      variant: .destructive,
      description: Text(_rocketchat_err_to_string(tr, err)),
    );
    context.pop();
  }
}
