import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:parkmate/models/spot.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/providers/spot_seeker_provider.dart';
import 'package:parkmate/widgets/snackbar.dart';
import 'package:provider/provider.dart';

Future<void> getRegisteredSpotsData(BuildContext context) async {
  final SpotSeekerProvider spotSeekerProvider =
      context.read<SpotSeekerProvider>();
  final AppProvider appProvider = context.read<AppProvider>();
  try {
    spotSeekerProvider.isFetchingSpots = true;
    List<Spot> spots = [];
    Stream<Map<String, dynamic>>? spotStream = appProvider.db
        ?.collection('spots')
        .find(where.eq('owner', appProvider.user?.email));
    print(appProvider.user?.email);
    if (spotStream == null) {
      throw Exception('No spots found');
    }
    spotStream.listen(
      (event) {
        Spot spot = Spot.fromJson(event);
        spots.add(spot);
      },
      onDone: () {
        spotSeekerProvider.spots = spots;
        spotSeekerProvider.isFetchingSpots = false;
      },
    );
  } catch (e) {
    showInSnackBar(context, e.toString(), isError: true);
  }
}
