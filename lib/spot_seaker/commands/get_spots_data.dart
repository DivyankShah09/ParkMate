import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:parkmate/models/spot.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/providers/spot_seeker_provider.dart';
import 'package:parkmate/widgets/snackbar.dart';
import 'package:provider/provider.dart';

Future<void> getParkingSpotsData(BuildContext context) async {
  final SpotSeekerProvider spotSeekerProvider =
      context.read<SpotSeekerProvider>();
  final AppProvider appProvider = context.read<AppProvider>();

  try {
    spotSeekerProvider.isFetchingSpots = true;
    spotSeekerProvider.spots = [];
    await appProvider.db?.open();
    Stream<Map<String, dynamic>>? spotStream =
        appProvider.db?.collection('spots').find();
    if (spotStream == null) {
      throw Exception('No spots found');
    }
    print("spotStream: $spotStream");
    spotStream.listen(
      (event) {
        Spot spot = Spot.fromJson(event);
        spotSeekerProvider.spots.add(spot);
      },
      onDone: () {
        spotSeekerProvider.isFetchingSpots = false;
      },
    );
    spotSeekerProvider.searchQuery = '';
  } catch (e) {
    showInSnackBar(context, e.toString(), isError: true);
    spotSeekerProvider.isFetchingSpots = false;
  }
}
