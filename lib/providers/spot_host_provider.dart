import 'package:flutter/material.dart';

class SpotHostProvider extends ChangeNotifier {
  String _name = '';
  String get name => _name;
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  String _addressLine1 = '';
  String get addressLine1 => _addressLine1;
  void setAddressLine1(String addressLine1) {
    _addressLine1 = addressLine1;
    notifyListeners();
  }

  String _city = '';
  String get city => _city;
  void setCity(String city) {
    _city = city;
    notifyListeners();
  }

  String _province = '';
  String get province => _province;
  void setProvince(String province) {
    _province = province;
    notifyListeners();
  }

  String _pinCode = '';
  String get pinCode => _pinCode;
  void setPinCode(String pinCode) {
    _pinCode = pinCode;
    notifyListeners();
  }

  double? _latitude;
  double? get latitude => _latitude;
  void setLatitude(double latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  double? _longitude;
  double? get longitude => _longitude;
  void setLongitude(double longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  int ratePerHour = 0;
  void setRatePerHour(int ratePerHour) {
    this.ratePerHour = ratePerHour;
    notifyListeners();
  }

  String _image = '';
  String get image => _image;
  void setImage(String image) {
    _image = image;
    notifyListeners();
  }

  // validate name
  String? validateName(String? name) {
    if (name == null) return null;
    if (name.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  // validate address
  String? validateAddress(String? addressLine1) {
    if (addressLine1 == null) return null;
    if (addressLine1.isEmpty) {
      return 'Address Line 1 is required';
    }
    return null;
  }

  // validate city
  String? validateCity(String? city) {
    if (city == null) return null;
    if (city.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  // validate province
  String? validateProvince(String? province) {
    if (province == null) return null;
    if (province.isEmpty) {
      return 'Province is required';
    }
    return null;
  }

  // validate pin code
  String? validatePinCode(String? pinCode) {
    if (pinCode == null) return null;
    if (pinCode.isEmpty) {
      return 'Pin Code is required';
    }
    return null;
  }

  String? validateLatitudeLongitude(double? value) {
    if (value == null) {
      return 'This field is required';
    }
    return null;
  }

  String? validateRatePerHour(int value) {
    if (value == 0) {
      return 'Rate per hour is required';
    }
    return null;
  }

  String? validateImage(String? image) {
    if (image == null) return null;
    if (image.isEmpty) {
      return 'Image is required';
    }
    return null;
  }

  bool validateSpotRegistrationForm() {
    final nameError = validateName(_name);
    final addressLine1Error = validateAddress(_addressLine1);
    final cityError = validateCity(_city);
    final provinceError = validateProvince(_province);
    final pinCodeError = validatePinCode(_pinCode);
    final latitudeError = validateLatitudeLongitude(_latitude);
    final longitudeError = validateLatitudeLongitude(_longitude);
    final ratePerHourError = validateRatePerHour(ratePerHour);
    final imageError = validateImage(_image);

    return nameError == null &&
        addressLine1Error == null &&
        cityError == null &&
        provinceError == null &&
        pinCodeError == null &&
        latitudeError == null &&
        longitudeError == null &&
        ratePerHourError == null &&
        imageError == null;
  }

  void clear() {
    _name = '';
    _addressLine1 = '';
    _city = '';
    _province = '';
    _pinCode = '';
    _latitude = null;
    _longitude = null;
    ratePerHour = 0;
    _image = '';
    notifyListeners();
  }
}
