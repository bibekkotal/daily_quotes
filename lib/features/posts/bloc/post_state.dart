part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostSuccess extends PostState {}

class PostError extends PostState {
  final String errorMessage;

  const PostError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PostsLoaded extends PostState {
  final Stream<List<PostEntity>> postsStream;
  const PostsLoaded(this.postsStream);
}
