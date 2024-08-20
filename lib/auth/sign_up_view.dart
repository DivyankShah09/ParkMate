import 'package:flutter/material.dart';
import 'package:parkmate/auth/login_view.dart';
import 'package:parkmate/commands/firebase_analytics.dart';
import 'package:parkmate/constants/colors.dart';
import 'package:parkmate/providers/auth_provider.dart';
import 'package:parkmate/widgets/custom_text_field.dart';
import 'package:parkmate/widgets/park_mate_button.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';
import 'package:provider/provider.dart';

import 'commands/auth_commands.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    AnalyticsCommand.logScreenView('Sign Up View');
  }

  @override
  Widget build(BuildContext context) {
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
                  'Create an account',
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
                //name
                CustomTextField(
                    onChange: (value) {
                      authProvider.setName(value);
                      setState(() {});
                    },
                    label: 'Name',
                    validator: authProvider.validateName,
                    hintText: 'Enter your name'),
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
                // confirm password input
                CustomTextField(
                  onChange: (value) {
                    authProvider.setConfirmPassword(value);
                    setState(() {});
                  },
                  label: 'Confirm Password',
                  validator: authProvider.validateConfirmPassword,
                  hintText: 'Confirm your password',
                  obscureText: true,
                ),
                VSpace.med,
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
                VSpace.lg,

                ParkMateButton(
                    isEnabled: authProvider.validateSignUpForm() && !isLoading,
                    onTap: isLoading
                        ? () {}
                        : () async {
                            isLoading = true;
                            setState(() {});
                            await signup(context);
                            isLoading = false;
                            setState(() {});
                          },
                    text: isLoading ? "Creating..." : "Create Account"),
                VSpace.lg,
                GestureDetector(
                  onTap: () {
                    authProvider.clear();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                  child: Text(
                    'Already have an account? Login',
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
