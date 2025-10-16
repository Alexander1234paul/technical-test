// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_model.dart';

class PreferenceModelAdapter extends TypeAdapter<PreferenceModel> {
  @override
  final int typeId = 0;

  @override
  PreferenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreferenceModel(
      id: fields[0] as String,
      customName: fields[1] as String,
      apiName: fields[2] as String,
      apiUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PreferenceModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customName)
      ..writeByte(2)
      ..write(obj.apiName)
      ..writeByte(3)
      ..write(obj.apiUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
