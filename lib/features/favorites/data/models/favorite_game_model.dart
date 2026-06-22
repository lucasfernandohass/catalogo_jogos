class FavoriteGameModel {
  final int id;
  final String name;
  final String image;

  FavoriteGameModel({
    required this.id,
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory FavoriteGameModel.fromMap(Map<String, dynamic> map) {
    return FavoriteGameModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
    );
  }
}