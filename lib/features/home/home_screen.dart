import '../../repository/post_repository.dart';
import '../../utils/app_exports.dart';
import '../login/bloc/auth_bloc.dart';
import '../posts/bloc/post_bloc.dart';
import '../posts/post_page.dart';
import '../posts/posts_creation_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PostsRepository postsRepository;

  @override
  void initState() {
    super.initState();
    postsRepository = PostsRepository(
      fireStore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      storage: FirebaseStorage.instance,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: AppColors.white,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<PostBloc>(
            create: (context) => PostBloc(postsRepository: postsRepository)),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }

                if (state is LogoutSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );

                  NavigatorService.pushNamedAndRemoveUntil(RouteNames.login);
                }
              },
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return CustomAppBar(
                      imageUrl: state.user.photoURL,
                      displayName: state.user.displayName.toString(),
                      onLogout: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                    );
                  } else {
                    return CustomAppBar(
                      imageUrl: null,
                      displayName: StaticStrings.appName,
                      onLogout: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                    );
                  }
                },
              ),
            ),
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return PostsFeedWidget(user: state.user);
              }
              return const SizedBox.shrink();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreatePostDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
          BlocProvider<PostBloc>(
              create: (context) => PostBloc(postsRepository: postsRepository)),
        ],
        child: Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: Text(StaticStrings.createPosts,
                  style: TextStyle(color: AppColors.black)),
              centerTitle: true,
              backgroundColor: AppColors.white,
              elevation: 0,
              shadowColor: AppColors.white,
              iconTheme: IconThemeData(color: AppColors.black),
            ),
            body: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return CreatePostWidget(user: state.user);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
