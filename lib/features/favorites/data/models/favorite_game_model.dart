class FavoriteGameModel {
  final int id;
  final String name;
  final String image;
  final double rating;

  FavoriteGameModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
    };
  }

  factory FavoriteGameModel.fromMap(Map<String, dynamic> map) {
    return FavoriteGameModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }
}