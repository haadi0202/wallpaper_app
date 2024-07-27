// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PictureAdapter extends TypeAdapter<Picture> {
  @override
  final int typeId = 1;

  @override
  Picture read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Picture(
      id: fields[0] as int,
      width: fields[1] as int,
      height: fields[2] as int,
      photographer: fields[3] as String,
      url: fields[4] as String,
      smallUrl: fields[5] as String,
      large: fields[6] as String,
      avgColor: fields[7] as String,
    )..liked = fields[8] as bool;
  }

  @override
  void write(BinaryWriter writer, Picture obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.photographer)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.smallUrl)
      ..writeByte(6)
      ..write(obj.large)
      ..writeByte(7)
      ..write(obj.avgColor)
      ..writeByte(8)
      ..write(obj.liked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PictureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
