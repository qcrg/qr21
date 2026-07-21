import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_dm_room.freezed.dart';
part 'create_dm_room.g.dart';

@freezed
@immutable
abstract class CreateDmRoom with _$CreateDmRoom {
  factory CreateDmRoom({
    @JsonKey(name: 'rid') required String id,
    required String t,
    required List<String> usernames,
  }) = _CreateDmRoom;

  factory CreateDmRoom.fromJson(Map<String, dynamic> json) =>
      _$CreateDmRoomFromJson(json);
}
