import '../data/posts_data.dart';
import '../utils/app_exports.dart';

class PostsRepository {
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  PostsRepository({
    required this.fireStore,
    required this.auth,
    required this.storage,
  });

  Stream<List<PostEntity>> getPosts() {
    return fireStore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromFireStore(doc).toEntity())
            .toList());
  }

  Future<void> createPost({
    required String quote,
    String? authorImage,
    String? authorName,
    String? location,
    required String bgColorCode,
  }) async {
    final postModel = PostModel(
      id: '',
      quote: quote,
      authorId: auth.currentUser?.uid ?? '',
      createdAt: DateTime.now(),
      authorImage: authorImage ?? '',
      authorName: authorName ?? '',
      location: location ?? '',
      bgColorCode: bgColorCode,
    );

    await fireStore.collection('posts').add(postModel.toFireStore());
  }

  Future<void> deletePost(String postId) async {
    await fireStore.collection('posts').doc(postId).delete();
  }
}

class PostEntity extends Equatable {
  final String id;
  final String quote;
  final String bgColorCode;
  final String authorId;
  final String authorImage;
  final DateTime createdAt;
  final String location;
  final String authorName;

  const PostEntity({
    required this.id,
    required this.quote,
    required this.bgColorCode,
    required this.authorId,
    required this.authorImage,
    required this.createdAt,
    required this.location,
    required this.authorName,
  });

  @override
  List<Object?> get props => [
        id,
        quote,
        bgColorCode,
        authorId,
        authorImage,
        createdAt,
        location,
        authorName,
      ];
}
