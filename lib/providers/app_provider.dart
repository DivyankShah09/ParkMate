import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:parkmate/commands/shared_preferences.dart';
import 'package:parkmate/models/user.dart';

class AppProvider extends ChangeNotifier {
  Db? _db;
  Db? get db => _db;
  set db(Db? db) {
    _db = db;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;
  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  void signOut() {
    _user = null;
    SharedPreferencesCommand.clear();
    notifyListeners();
  }
}
