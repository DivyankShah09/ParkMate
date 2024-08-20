import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:parkmate/auth/commands/auth_commands.dart';
import 'package:parkmate/auth/login_view.dart';
import 'package:parkmate/auth/sign_up_view.dart';
import 'package:parkmate/commands/connect_mongodb.dart';
import 'package:parkmate/commands/shared_preferences.dart';
import 'package:parkmate/providers/auth_provider.dart';
import 'package:parkmate/widgets/park_mate_button.dart';
import 'package:parkmate/widgets/styles.dart';
import 'package:parkmate/constants/colors.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    mongo.Db db = await connectMongoDB(context);
    if (await SharedPreferencesCommand.isLoggedIn) {
      await login(context, db: db);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(image: AssetImage("assets/images/Logo.png")),
            const VSpace(Insets.lg * 1.5),
            Text(
              "The Faster. Smarter. The Spotter.",
              style: TextStyles.h2.copyWith(fontSize: 32.0),
              textAlign: TextAlign.center,
            ),
            const VSpace(Insets.lg * 1.5),
            Text(
              "Effortless parking awaits. Park Mate guides you to open spots, hassle-free.",
              style: TextStyles.body1.copyWith(color: kGrey),
              textAlign: TextAlign.center,
            ),
            VSpace.lg,
            ParkMateButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpView()));
                },
                text: "Create Account"),
            VSpace.lg,
            ParkMateButton(
              onTap: () async {
                context.read<AuthProvider>().clear();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginView()));
              },
              text: "Login",
              buttonColor: Colors.transparent,
              textColor: kPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
