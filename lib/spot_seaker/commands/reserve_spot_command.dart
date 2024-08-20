import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:parkmate/commands/firebase_analytics.dart';
import 'package:parkmate/models/bookings.dart';
import 'package:parkmate/models/spot.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/widgets/snackbar.dart';
import 'package:provider/provider.dart';

Future<bool> reserveSpot(
    BuildContext context, Spot spot, int duration, TimeOfDay startTime) async {
  final String? userEmail = context.read<AppProvider>().user?.email;
  final DateTime current = DateTime.now();
  final DateTime now = DateTime(current.year, current.month, current.day,
      startTime.hour, startTime.minute);
  final DateTime end = now.add(Duration(minutes: duration));
  if (userEmail != null) {
    // check if now and end is there in the spot or not
    if (spot.bookingDates.every((bookedDateTimes) =>
        !(now.isAfter(bookedDateTimes.startingDateTime!) &&
                now.isBefore(bookedDateTimes.endingDateTime!) ||
            end.isAfter(bookedDateTimes.startingDateTime!) &&
                end.isBefore(bookedDateTimes.endingDateTime!)))) {
      // if not then add the booking
      spot.bookingDates
          .add(BookedSlotsDateTime(startingDateTime: now, endingDateTime: end));
      await context.read<AppProvider>().db?.collection('spots').update(
          where.eq('name', spot.name),
          modify.set('bookingDates',
              spot.bookingDates.map((dateTime) => dateTime.toJson()).toList()));

      Bookings booking = Bookings(
        spot: spot,
        userEmail: userEmail,
        bookingDate: now,
        duration: duration,
        totalAmount: spot.ratePerHr * (duration ~/ 60),
      );
      // also add this to bookings collection
      await context
          .read<AppProvider>()
          .db
          ?.collection('bookings')
          .insert(booking.toJson());

      AnalyticsCommand.logEvent("spot_book");

      showInSnackBar(context, 'Spot reserved successfully');
      return true;
    } else {
      showInSnackBar(context, 'Spot is already booked for this time');
      return false;
    }
  } else {
    showInSnackBar(context, 'Please login to reserve a spot');
    return false;
  }
}
