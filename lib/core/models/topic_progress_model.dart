class TopicProgressModel {
  final int id;
  final String name;
  final String iconId;
  final String colorHex;
  final int totalRead;
  final int totalPages;

  TopicProgressModel({
    required this.id,
    required this.name,
    required this.iconId,
    required this.colorHex,
    required this.totalRead,
    required this.totalPages,
  });

  factory TopicProgressModel.fromMap(Map<String, dynamic> map) {
    return TopicProgressModel(
      id: map['id'],
      name: map['name'],
      iconId: map['icon_id'],
      colorHex: map['color_hex'],
      totalRead: map['total_read'],
      totalPages: map['total_pages'],
    );
  }
}
