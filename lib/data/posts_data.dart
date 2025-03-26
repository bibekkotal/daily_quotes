import '../repository/post_repository.dart';
import '../utils/app_exports.dart';

class PostModel {
  final String id;
  final String quote;
  final String bgColorCode;
  final String authorId;
  final String authorImage;
  final DateTime createdAt;
  final String location;

  PostModel({
    required this.id,
    required this.quote,
    required this.bgColorCode,
    required this.authorId,
    required this.authorImage,
    required this.createdAt,
    required this.location,
  });

  factory PostModel.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PostModel(
      id: doc.id,
      quote: data['quote'] ?? '',
      bgColorCode: data['bg_color_code'] ?? '#FFFFFF',
      authorId: data['authorId'] ?? '',
      authorImage: data['author_image'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      location: data['location'] ?? '',
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      quote: quote,
      bgColorCode: bgColorCode,
      authorId: authorId,
      authorImage: authorImage,
      createdAt: createdAt,
      location: location,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'quote': quote,
      'bg_color_code': bgColorCode,
      'authorId': authorId,
      'author_image': authorImage,
      'createdAt': createdAt,
      'location': location,
    };
  }
}
