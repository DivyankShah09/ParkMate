import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parkmate/commands/firebase_analytics.dart';
import 'package:parkmate/commands/shared_preferences.dart';
import 'package:parkmate/constants/colors.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/providers/auth_provider.dart';
import 'package:parkmate/providers/spot_host_provider.dart';
import 'package:parkmate/providers/spot_seeker_provider.dart';
import 'package:parkmate/splash_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AnalyticsCommand.init();
  await SharedPreferencesCommand.init();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => SpotSeekerProvider()),
        ChangeNotifierProvider(create: (_) => SpotHostProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initFirebaseAnalytics({});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B4A42)),
        primaryColor: kPrimary,
        useMaterial3: true,
      ),
      home: const SafeArea(child: Scaffold(body: SplashView())),
      // home: const ParkingConfirmation(),
    );
  }
}
