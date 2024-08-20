import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parkmate/firebase_options.dart';

class AnalyticsCommand {
  static final analyticsInstance = FirebaseAnalytics.instance;

  static Future<void> init() async {
    log('Firebase Analytics initialized');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('App Open Event Logged');
    await analyticsInstance.logAppOpen();
  }

  static void logEvent(String name, {Map<String, Object>? parameters}) async {
    log('Firebase Analytics Event Logged: $name');
    await analyticsInstance.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  static void logLoginEvent(String method) async {
    log('Firebase Analytics Login Event Logged: $method');
    await analyticsInstance.logLogin(
      loginMethod: method,
    );
  }

  static void logSignUpEvent(String method) async {
    log('Firebase Analytics Sign Up Event Logged: $method');
    await analyticsInstance.logSignUp(
      signUpMethod: method,
    );
  }

  static void logAppOpenEvent(Map<String, Object> parameters) async {
    log('Firebase Analytics App Open Event Logged');
    await analyticsInstance.logAppOpen(
      parameters: parameters,
    );
  }

  static void logScreenView(String screenName) async {
    log('Firebase Analytics Screen View Logged: $screenName');
    await analyticsInstance.logScreenView(
      screenName: screenName,
    );
  }
}

void initFirebaseAnalytics(Map<String, Object> parameters) async {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  log('Firebase Analytics initialized');
  // await analytics.setUserId(id: 'user_123');
  await analytics.logAppOpen(
    parameters: parameters,
  );
  // login event
  await analytics.logLogin(loginMethod: 'email');
}
