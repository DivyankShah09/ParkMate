import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:parkmate/commands/firebase_analytics.dart';
import 'package:parkmate/models/spot.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/providers/spot_host_provider.dart';
import 'package:parkmate/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<void> addSpot(BuildContext context) async {
  SpotHostProvider spotHostProvider = context.read<SpotHostProvider>();

  try {
    Spot spot = Spot(
      name: spotHostProvider.name,
      location:
          '${spotHostProvider.addressLine1}, ${spotHostProvider.city}, ${spotHostProvider.province}, ${spotHostProvider.pinCode}',
      owner: context.read<AppProvider>().user!.email,
      facilities: [
        'Security',
        'CCTV',
      ],
      bookingDates: [],
      rating: 3.5,
      discount: 5,
      coordinates: LatLng(
          spotHostProvider.latitude ?? 0.0, spotHostProvider.longitude ?? 0.0),
      ratePerHr: spotHostProvider.ratePerHour,
      image: spotHostProvider.image,
    );

    dynamic res = await context
        .read<AppProvider>()
        .db
        ?.collection('spots')
        .insert(spot.toJson());
    if (res != null) {
      showInSnackBar(context, 'Spot added successfully');
      AnalyticsCommand.logEvent("Spot Added");
      Navigator.of(context).pop(true);
    } else {
      showInSnackBar(context, 'Failed to add spot');
    }
  } catch (e) {
    showInSnackBar(context, 'Failed to add spot');
  }
}
