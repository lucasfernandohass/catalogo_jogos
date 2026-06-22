class GameModel {
  final int id;
  final String name;
  final String image;

  GameModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'],
      name: map['name'],
      image: map['background_image'] ?? '',
    );
  }
}