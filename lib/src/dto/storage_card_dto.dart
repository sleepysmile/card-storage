class StorageCardDto {
  const StorageCardDto({
    required this.id,
    required this.name,
    required this.barcode,
    this.cardNumber,
  });

  final int id;
  final String name;
  final String barcode;
  final String? cardNumber;

  factory StorageCardDto.fromJson(Map<String, dynamic> json) => StorageCardDto(
        id: json['id'] as int,
        name: json['name'] as String,
        barcode: json['barcode'] as String,
        cardNumber: json['cardNumber'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'barcode': barcode,
        'cardNumber': cardNumber,
      };

  StorageCardDto copyWith({
    int? id,
    String? name,
    String? barcode,
    String? cardNumber,
  }) {
    return StorageCardDto(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      cardNumber: cardNumber ?? this.cardNumber,
    );
  }
}
