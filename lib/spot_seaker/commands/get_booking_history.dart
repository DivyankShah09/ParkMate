import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:parkmate/models/bookings.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:provider/provider.dart';

Future<List<Bookings>> getBookingHistory(
    BuildContext context, bool isHost) async {
  final String? userEmail = context.read<AppProvider>().user?.email;
  final List<Bookings> bookings = [];
  if (userEmail != null) {
    final List<Map<String, dynamic>> res = await context
            .read<AppProvider>()
            .db
            ?.collection('bookings')
            .find(where.eq(isHost ? 'spot.owner' : 'userEmail', userEmail))
            .toList() ??
        [];

    res.map((booking) => bookings.add(Bookings.fromJson(booking))).toList();

    return bookings;
  }
  return [];
}
