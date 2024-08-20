import 'package:flutter/widgets.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:provider/provider.dart';

Future<int> getTotalEarnings(BuildContext context) async {
  final String? userEmail = context.read<AppProvider>().user?.email;
  if (userEmail != null) {
    final List<Map<String, dynamic>> res = await context
            .read<AppProvider>()
            .db
            ?.collection('bookings')
            .find(where.eq('spot.owner', userEmail))
            .toList() ??
        [];

    return res.fold<int>(
        0,
        (previousValue, element) =>
            previousValue + element['totalAmount'] as int);
  }
  return 0;
}
