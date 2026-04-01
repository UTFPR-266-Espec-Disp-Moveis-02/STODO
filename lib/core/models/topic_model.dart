class TopicModel {
  final int? id;
  final String name;
  final String iconId;
  final String colorHex;

  TopicModel({
    required this.id,
    required this.name,
    required this.iconId,
    required this.colorHex
  });

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      id: map['id'],
      name: map['name'],
      iconId: map['icon_id'],
      colorHex: map['color_hex'],
    );
  }
}