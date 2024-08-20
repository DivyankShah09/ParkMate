import 'package:flutter/material.dart';
import 'package:parkmate/auth/commands/auth_commands.dart';
import 'package:parkmate/auth/sign_up_view.dart';
import 'package:parkmate/commands/firebase_analytics.dart';
import 'package:parkmate/constants/colors.dart';
import 'package:parkmate/widgets/custom_text_field.dart';
import 'package:parkmate/widgets/park_mate_button.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

enum UserType { host, seeker }

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    AnalyticsCommand.logScreenView("Login View");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider =
        context.select((AuthProvider authProvider) => authProvider);
    final UserType groupValue =
        context.select((AuthProvider authProvider) => authProvider.groupValue);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VSpace.lg,
                Text(
                  'Login',
                  style: TextStyles.h2.copyWith(fontSize: 32.0),
                ),
                VSpace.sm,
                // start reserving spots now
                Text(
                  'Start reserving spots now',
                  style: TextStyles.callout1
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                const VSpace(
                  Insets.xl * 2,
                ), // email input
                CustomTextField(
                    onChange: (value) {
                      authProvider.setEmail(value);
                      setState(() {});
                    },
                    label: 'Email',
                    validator: authProvider.validateEmail,
                    hintText: 'Enter your email'),
                VSpace.lg,
                // password input
                CustomTextField(
                  onChange: (value) {
                    authProvider.setPassword(value);
                    setState(() {});
                  },
                  label: 'Password',
                  validator: authProvider.validatePassword,
                  hintText: 'Enter your password',
                  obscureText: true,
                ),

                VSpace.lg,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('User Type',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontSize: 16.0)),
                ),
                Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: VisualDensity.compact,
                          value: UserType.seeker,
                          groupValue: groupValue,
                          onChanged: (value) {
                            authProvider
                                .setGroupValue(value ?? UserType.seeker);
                          }),
                      const Text("Spot Seeker"),
                      HSpace.xl,
                      Radio(
                          value: UserType.host,
                          groupValue: groupValue,
                          onChanged: (value) {
                            authProvider
                                .setGroupValue(value ?? UserType.seeker);
                          }),
                      const Text("Spot Host"),
                    ],
                  ),
                ),
                // login button
                ParkMateButton(
                    isEnabled: authProvider.validateLoginForm() && !isLoading,
                    onTap: () async {
                      isLoading = true;
                      setState(() {});
                      await login(context);
                      isLoading = false;
                      setState(() {});
                    },
                    text: isLoading ? "Logging In..." : "Login"),
                VSpace.lg,
                GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                          authProvider.clear();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpView()));
                        },
                  child: Text(
                    "Don't have an account? Register Now",
                    style: TextStyles.body1.copyWith(color: kPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
