import 'package:parkmate/models/spot.dart';

class Bookings {
  String? id;
  Spot? spot;
  String? userEmail;
  DateTime? bookingDate;
  int? duration;
  int? totalAmount;

  Bookings({
    this.id,
    this.spot,
    this.userEmail,
    this.bookingDate,
    this.duration,
    this.totalAmount,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) {
    return Bookings(
      id: json['_id'].toString(),
      spot: Spot.fromJson(json['spot']),
      userEmail: json['userEmail'],
      bookingDate: DateTime.parse(json['bookingDate']),
      duration: json['duration'],
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spot': spot?.toJson(),
      'userEmail': userEmail,
      'bookingDate': bookingDate?.toIso8601String(),
      'duration': duration,
      'totalAmount': totalAmount,
    };
  }
}
