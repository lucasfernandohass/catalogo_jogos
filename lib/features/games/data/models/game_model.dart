class GameModel {
  final int id;
  final String name;
  final String image;
  final double rating;

  GameModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      name: json['name'],
      image: json['background_image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}