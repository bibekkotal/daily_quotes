import '../features/home/home_screen.dart';
import '../utils/app_exports.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StaticStrings.error)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(StaticStrings.pageNotFound),
            ElevatedButton(
              child: Text(StaticStrings.goToHome),
              onPressed: () {
                // Navigator.pushNamedAndRemoveUntil(
                //     context,
                //     RouteNames.home,
                //         (route) => false
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
