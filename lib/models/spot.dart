import 'package:latlong2/latlong.dart';

class Spot {
  String name;
  String location;
  String owner;
  String image;
  List<String> facilities;
  int ratePerHr;
  List<BookedSlotsDateTime> bookingDates;
  double rating;
  int discount;
  LatLng? coordinates;

  Spot({
    required this.name,
    required this.location,
    this.owner = '',
    required this.image,
    required this.facilities,
    required this.ratePerHr,
    required this.bookingDates,
    this.rating = 0.0,
    this.discount = 0,
    this.coordinates,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    json.remove('_id');
    return Spot(
      name: json['name'],
      location: json['location'],
      image: json['image'],
      owner: json['owner'],
      facilities: List<String>.from(json['facilities']),
      ratePerHr: json['ratePerHr'],
      bookingDates: json['bookingDates'] != null
          ? List<BookedSlotsDateTime>.from(
              json['bookingDates']
                  .map((date) => BookedSlotsDateTime.fromJson(date)),
            )
          : [],
      rating: json['rating'],
      discount: json['discount'],
      coordinates: json['lat'] != null && json['long'] != null
          ? LatLng(json['lat'], json['long'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'image': image,
      'owner': owner,
      'facilities': facilities,
      'ratePerHr': ratePerHr,
      'bookingDates':
          bookingDates.map((dateTime) => dateTime.toJson()).toList(),
      'rating': rating,
      'discount': discount,
      'lat': coordinates?.latitude,
      'long': coordinates?.longitude,
    };
  }
}

class BookedSlotsDateTime {
  DateTime? startingDateTime;
  DateTime? endingDateTime;

  BookedSlotsDateTime({this.startingDateTime, this.endingDateTime});

  factory BookedSlotsDateTime.fromJson(Map<String, dynamic> json) {
    return BookedSlotsDateTime(
      startingDateTime: DateTime.parse(json['startingDateTime']),
      endingDateTime: DateTime.parse(json['endingDateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startingDateTime': startingDateTime?.toIso8601String(),
      'endingDateTime': endingDateTime?.toIso8601String(),
    };
  }
}
