// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class QrDataAdapter extends TypeAdapter<QrData> {
  @override
  final typeId = 0;

  @override
  QrData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QrData(
      username: fields[3] as String,
      src: fields[6] as String,
      expires: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QrData obj) {
    writer
      ..writeByte(3)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(5)
      ..write(obj.expires)
      ..writeByte(6)
      ..write(obj.src);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RocketChatCredsAdapter extends TypeAdapter<RocketChatCreds> {
  @override
  final typeId = 1;

  @override
  RocketChatCreds read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RocketChatCreds(
      baseUrl: fields[0] as String,
      username: fields[1] as String,
      userId: fields[2] as String,
      authToken: fields[3] as String,
      botRoomId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RocketChatCreds obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.baseUrl)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.authToken)
      ..writeByte(4)
      ..write(obj.botRoomId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RocketChatCredsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
