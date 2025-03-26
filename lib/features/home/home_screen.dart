import '../../utils/app_exports.dart';
import '../login/bloc/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
          // body: const TaskListPage(),
        ),
      ),
    );
  }
}
