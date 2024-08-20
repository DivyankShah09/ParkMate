import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:parkmate/auth/login_view.dart';
import 'package:parkmate/commands/firebase_analytics.dart';
import 'package:parkmate/commands/shared_preferences.dart';
import 'package:parkmate/models/user.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/providers/auth_provider.dart';
import 'package:parkmate/spot_host/commands/get_registered_spots.dart';
import 'package:parkmate/spot_host/host_dashboard.dart';
import 'package:parkmate/spot_seaker/commands/get_spots_data.dart';
import 'package:parkmate/spot_seaker/dashboard_seeker.dart';
import 'package:parkmate/widgets/snackbar.dart';
import 'package:provider/provider.dart';

Future<void> signup(BuildContext context) async {
  final AuthProvider authProvider = context.read<AuthProvider>();
  final AppProvider appProvider = context.read<AppProvider>();

  User user = User(
    email: authProvider.email,
    name: authProvider.name,
    password: authProvider.password,
    type: authProvider.groupValue,
  );
  try {
    await appProvider.db?.open();
    // check if user already exists
    var userExists = await appProvider.db
        ?.collection('users')
        .findOne({'email': user.email, 'type': user.type.name});
    if (userExists != null) {
      throw Exception('User already exists');
    }

    await appProvider.db?.collection('users').insert(user.toJson());
    showInSnackBar(context, 'User created successfully');
    authProvider.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false);
  } catch (e) {
    showInSnackBar(context, e.toString(), isError: true);
  }
}

Future<void> login(BuildContext context, {Db? db}) async {
  final AuthProvider authProvider = context.read<AuthProvider>();
  final AppProvider appProvider = context.read<AppProvider>();

  try {
    String email = authProvider.email;
    String password = authProvider.password;
    UserType type = authProvider.groupValue;
    if (await SharedPreferencesCommand.isLoggedIn) {
      log('User already logged in');
      email = await SharedPreferencesCommand.getString('email') ?? '';
      password = await SharedPreferencesCommand.getString('password') ?? '';
      type = await SharedPreferencesCommand.getString('type') == 'host'
          ? UserType.host
          : UserType.seeker;
    }
    User user = User(email: email, password: password, name: '', type: type);
    if (db != null) {
      appProvider.db = db;
    }
    await appProvider.db?.open();
    var res = await appProvider.db?.collection('users').findOne({
      'email': email,
      'password': user.toJson()['password'],
      'type': user.toJson()['type']
    });
    if (res == null) {
      throw Exception('Incorrect email or password');
    }
    print(res);

    if (!(await SharedPreferencesCommand.isLoggedIn)) {
      AnalyticsCommand.logLoginEvent("email");
    }

    user = User.fromJson(res);
    appProvider.user = user;

    SharedPreferencesCommand.setString('email', user.email);
    SharedPreferencesCommand.setString('type', user.type.name);
    SharedPreferencesCommand.setString('password', password);

    showInSnackBar(context, 'User logged in successfully');
    user.type == UserType.seeker
        ? await getParkingSpotsData(context)
        : await getRegisteredSpotsData(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => user.type == UserType.seeker
                ? const DashboardSeeker()
                : const HostDashboard()),
        (route) => false);
  } catch (e) {
    showInSnackBar(context, e.toString(), isError: true);
  }
}
