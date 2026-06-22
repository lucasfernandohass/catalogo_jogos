class GameDetailsModel {
  final int id;
  final String name;
  final String image;
  final double rating;
  final int ratingCount;
  final String description;

  GameDetailsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.ratingCount,
    required this.description,
  });

  factory GameDetailsModel.fromMap(Map<String, dynamic> map) {
    return GameDetailsModel(
      id: map['id'],
      name: map['name'],
      image: map['background_image'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      ratingCount: map['ratings_count'] ?? 0,
      description: map['description_raw'] ?? '',
    );
  }
}