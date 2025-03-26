import '../../utils/app_exports.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: AppColors.white,
    ));
    Size mediaSize = MediaQuery.sizeOf(context);

    return BlocProvider(
      create: (context) =>
          SplashBloc()..add(SplashInitialEvent()), // Dispatch event here
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoading) {
            NavigatorService.pushNamedAndRemoveUntil(RouteNames.login);
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Center(
              child: Image.asset(
                AppImages.splashImage,
                height: mediaSize.height / 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
