import 'package:hive_ce/hive.dart';
import 'package:qr21/data/models/qr_data/qr_data.dart';
import 'package:qr21/data/models/rocketchat_creds/rocketchat_creds.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<QrData>(), AdapterSpec<RocketChatCreds>()])
// ignore: unused_element
void _() {}
