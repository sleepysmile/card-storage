import 'package:hive/hive.dart';

class StorageCardDto {
  const StorageCardDto({
    required this.id,
    required this.name,
    required this.barcode,
  });

  final int id;
  final String name;
  final String barcode;

  StorageCardDto copyWith({int? id, String? name, String? barcode}) {
    return StorageCardDto(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
    );
  }
}

class StorageCardDtoAdapter extends TypeAdapter<StorageCardDto> {
  @override
  final int typeId = 0;

  @override
  StorageCardDto read(BinaryReader reader) {
    final fieldsCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var index = 0; index < fieldsCount; index++)
        reader.readByte(): reader.read(),
    };

    return StorageCardDto(
      id: (fields[2] as int?) ?? 0,
      name: fields[0] as String,
      barcode: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StorageCardDto obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.barcode)
      ..writeByte(2)
      ..write(obj.id);
  }
}
