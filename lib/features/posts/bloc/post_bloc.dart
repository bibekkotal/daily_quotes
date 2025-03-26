import '../../../data/posts_data.dart';
import '../../../repository/post_repository.dart';
import '../../../utils/app_exports.dart';
part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostsRepository postsRepository;

  PostBloc({required this.postsRepository}) : super(PostInitial()) {
    on<CreatePostEvent>(_onCreatePost);
    on<DeletePostEvent>(_onDeletePost);
    on<FetchPostsEvent>(_onFetchPosts);
  }

  void _onCreatePost(CreatePostEvent event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());
      await postsRepository.createPost(
        quote: event.post.quote,
        authorImage: event.post.authorImage,
        location: event.post.location,
        bgColorCode: event.post.bgColorCode,
      );
      emit(PostSuccess());
      add(FetchPostsEvent());
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  void _onDeletePost(DeletePostEvent event, Emitter<PostState> emit) async {
    try {
      emit(PostLoading());
      await postsRepository.deletePost(event.postId);
      emit(PostSuccess());
      add(FetchPostsEvent());
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  void _onFetchPosts(FetchPostsEvent event, Emitter<PostState> emit) {
    emit(PostLoading());

    try {
      Stream<List<PostEntity>> postsStream = postsRepository.getPosts();
      emit(PostsLoaded(postsStream));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
