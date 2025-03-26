import '../../../data/posts_data.dart';
import '../../../utils/app_exports.dart';
part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  PostBloc() : super(PostInitial()) {
    on<CreatePostEvent>(_onCreatePost);
    on<DeletePostEvent>(_onDeletePost);
    on<FetchPostsEvent>(_onFetchPosts);
  }

  void _onCreatePost(CreatePostEvent event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());
      await _fireStore.collection('posts').add(event.post.toFireStore());
      emit(PostSuccess());
      add(FetchPostsEvent());
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  void _onDeletePost(DeletePostEvent event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());
      await _fireStore.collection('posts').doc(event.postId).delete();
      emit(PostSuccess());
      add(FetchPostsEvent());
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  void _onFetchPosts(FetchPostsEvent event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());
      Stream<QuerySnapshot> postsStream = _fireStore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots();
      emit(PostsLoaded(postsStream));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
