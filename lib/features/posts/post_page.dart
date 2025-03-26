import 'package:intl/intl.dart';
import '../../data/posts_data.dart';
import '../../repository/post_repository.dart';
import '../../utils/app_exports.dart';
import 'bloc/post_bloc.dart';

class PostsFeedWidget extends StatelessWidget {
  final User user;

  const PostsFeedWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(FetchPostsEvent());

    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PostsLoaded) {
          return StreamBuilder<List<PostEntity>>(
            stream: state.postsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(StaticStrings.noPostYet),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  PostEntity post = snapshot.data![index];
                  return _buildPostCard(
                    context,
                    PostModel(
                      id: post.id,
                      quote: post.quote,
                      bgColorCode: post.bgColorCode,
                      authorId: post.authorId,
                      authorImage: post.authorImage,
                      createdAt: post.createdAt,
                      location: post.location,
                      authorName: post.authorName,
                    ),
                  );
                },
              );
            },
          );
        }

        if (state is PostError) {
          return Center(
            child: Text('Error loading posts: ${state.errorMessage}'),
          );
        }

        return Center(child: Text(StaticStrings.initPost));
      },
    );
  }

  Widget _buildPostCard(BuildContext context, PostModel post) {
    return Card(
      color: Color(int.parse('0xFF${post.bgColorCode.substring(1)}'))
          .withOpacity(0.80),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.quote,
              style: TextStyle(
                color: _getContrastColor(post.bgColorCode),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(post.authorImage),
                      radius: 20,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                          post.authorName,
                          style: TextStyle(
                            color: _getContrastColor(post.bgColorCode),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 3,
                          child: Text(
                            post.location,
                            style: TextStyle(
                              color: _getContrastColor(post.bgColorCode),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  DateFormat('MMM d, HH:mm').format(post.createdAt),
                  style: TextStyle(
                    color: _getContrastColor(post.bgColorCode),
                    fontSize: 12,
                  ),
                ),
                if (post.authorId == user.uid)
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: _getContrastColor(post.bgColorCode),
                    ),
                    onPressed: () {
                      context.read<PostBloc>().add(DeletePostEvent(post.id));
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getContrastColor(String bgColorCode) {
    final color = Color(int.parse('0xFF${bgColorCode.substring(1)}'));
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
