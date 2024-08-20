// init auth provider
import 'package:flutter/material.dart';
import 'package:parkmate/auth/login_view.dart';

class AuthProvider extends ChangeNotifier {
  String _email = '';
  String get email => _email;
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;
  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  String _name = '';
  String get name => _name;
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  UserType _groupValue = UserType.seeker;
  UserType get groupValue => _groupValue;
  void setGroupValue(UserType groupValue) {
    _groupValue = groupValue;
    notifyListeners();
  }

  // validate email
  String? validateEmail(String? email) {
    final RegExp emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (email == null) return null;
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  // validate password
  String? validatePassword(String? password) {
    final RegExp passwordRegex =
        RegExp(r'^(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z]).{8,15}$');
    if (password == null) return null;
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (!passwordRegex.hasMatch(password)) {
      return 'Password should have: atleast 8 characters, 1 uppercase, \n1 lowercase, 1 alphabet and 1 special character.';
    }
    return null;
  }

  // validate confirm password
  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null) return null;
    if (confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }
    if (confirmPassword != _password) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateName(String? name) {
    if (name == null) return null;
    if (name.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  // validate sign up form
  bool validateSignUpForm() {
    final emailError = validateEmail(_email);
    final passwordError = validatePassword(_password);
    final confirmPasswordError = validateConfirmPassword(_confirmPassword);
    final nameError = validateName(_name);
    return emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        nameError == null;
  }

  // validate login form
  bool validateLoginForm() {
    final emailError = validateEmail(_email);
    final passwordError = validatePassword(_password);
    return emailError == null && passwordError == null;
  }

  void clear() {
    _email = '';
    _password = '';
    _confirmPassword = '';
    _name = '';
    notifyListeners();
  }
}
