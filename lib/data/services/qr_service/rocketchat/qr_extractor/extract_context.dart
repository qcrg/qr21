import 'dart:convert';

import 'package:rocketchat_sdk/rocketchat_sdk.dart';

class ExtractContext {
  final PndRocketChatAttachmentGetter attachment_getter;

  const ExtractContext({required this.attachment_getter});
}

class PndRocketChatAttachmentGetter {
  final RocketChatClient _client;

  const PndRocketChatAttachmentGetter({required this._client});

  Future<String?> downloadFileById(String fileId) async {
    final files = await _client.dm.files(
      roomIdentifier: .fromUsername("qr-code-generator.bot"),
      name: "qr-code.png",
      sort: {"uploadedAt": 1},
    );
    RocketChatAttachment? attachment;
    for (final file in files) {
      if (file.id == fileId) {
        attachment = file;
        break;
      }
    }
    if (attachment == null) {
      return null;
    }
    final file = await _client.attachments.download(attachment);
    return 'data:image/png;base64,${base64Encode(file)}';
  }
}
