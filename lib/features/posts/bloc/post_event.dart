part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class CreatePostEvent extends PostEvent {
  final PostModel post;

  const CreatePostEvent(this.post);

  @override
  List<Object> get props => [post];
}

class DeletePostEvent extends PostEvent {
  final String postId;

  const DeletePostEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

class FetchPostsEvent extends PostEvent {}
