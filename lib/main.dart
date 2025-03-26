import 'utils/app_exports.dart';

void main() async {
  RenderErrorBox.backgroundColor = Colors.black26;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DailyQuotes());
}

class DailyQuotes extends StatefulWidget {
  const DailyQuotes({super.key});

  @override
  State<DailyQuotes> createState() => _DailyQuotesState();
}

class _DailyQuotesState extends State<DailyQuotes> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: CustomFonts.FacultyGlyphic,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
        ),
        useMaterial3: false,
        typography: Typography.material2021(),
      ),
      title: StaticStrings.appName,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RouteNames.splash,
      navigatorKey: NavigatorService.navigatorKey,
    );
  }
}
