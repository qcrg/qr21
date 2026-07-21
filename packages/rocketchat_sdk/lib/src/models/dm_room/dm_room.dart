import 'package:freezed_annotation/freezed_annotation.dart';
import '../message/message.dart';

part 'dm_room.freezed.dart';
part 'dm_room.g.dart';

@freezed
@immutable
abstract class DmRoom with _$DmRoom {
  factory DmRoom({
    @JsonKey(name: '_id') required String id,
    required String t, // "d" for direct message
    required List<String> usernames,
    required int usersCount,
    required int msgs,
    required String ts,
    required List<String> uids,
    String? topic,
    String? name,
    String? fname,
    RocketChatMessage? lastMessage,
  }) = _DmRoom;

  factory DmRoom.fromJson(Map<String, dynamic> json) => _$DmRoomFromJson(json);
}
