import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:parkmate/commands/firebase_analytics.dart';
import 'package:parkmate/models/spot.dart';
import 'package:parkmate/spot_seaker/commands/reserve_spot_command.dart';
import 'package:parkmate/spot_seaker/parking_confirmation.dart';
import 'package:parkmate/spot_seaker/tile_provider.dart';
import 'package:parkmate/widgets/park_mate_button.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';

class SpotMap extends StatefulWidget {
  const SpotMap({super.key, required this.spots, this.isHost = false});
  final List<Spot> spots;
  final bool isHost;

  @override
  State<SpotMap> createState() => _SpotMapState();
}

class _SpotMapState extends State<SpotMap> {
  // write a code to init multiple markers on the maps here
  final double latitude = 44.651070;
  final double longitude = -63.582687;
  LocationData? locationData;
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  String locationName = 'Detecting location...';
  MapController mapController = MapController();
  late List<Spot> spots;
  int parkingTime = 60;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    spots = widget.spots;
    AnalyticsCommand.logScreenView('Spot Map View');
    initLocation();
  }

  void initLocation() async {
    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    print(
        "Location detected: ${locationData?.latitude}, ${locationData?.longitude}");
    List<geocode.Placemark> placemarks = await geocode.placemarkFromCoordinates(
        locationData?.latitude ?? latitude,
        locationData?.longitude ?? longitude);

    locationName =
        "${placemarks[0].name ?? ''}, ${placemarks[0].street ?? ''}, ${placemarks[0].locality ?? ''}";
    print(placemarks[0]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isHost
            ? 'Your spots in your area'
            : 'Parking Spots in Your Area'),
      ),
      body: locationName == 'Detecting location...'
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
                VSpace.lg,
                Text('Detecting location...'),
              ],
            )
          : Stack(
              children: [
                FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: LatLng(locationData?.latitude ?? latitude,
                          locationData?.longitude ?? longitude),
                      initialZoom: 15,
                      cameraConstraint: CameraConstraint.contain(
                        bounds: LatLngBounds(
                          const LatLng(-90, -180),
                          const LatLng(90, 180),
                        ),
                      ),
                      interactionOptions: const InteractionOptions(
                        flags: ~InteractiveFlag.doubleTapZoom,
                      ),
                    ),
                    children: [
                      openStreetMapTileLayer,
                      MarkerLayer(
                        rotate: false,
                        markers: List.generate(
                          spots.length,
                          (index) {
                            log("Spot: ${spots[index].name}\n"
                                "lat: ${spots[index].coordinates?.latitude}");

                            return Marker(
                              point: spots[index].coordinates ??
                                  LatLng(latitude, longitude),
                              width: 60,
                              height: 60,
                              child: GestureDetector(
                                onTap: () async {
                                  await showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(Insets.lg + 8),
                                        topRight:
                                            Radius.circular(Insets.lg + 8),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              36,
                                          child: Column(
                                            children: [
                                              Text(
                                                "YOUR SPOT AWAITS YOU",
                                                style: TextStyles.h3
                                                    .copyWith(fontSize: 24),
                                                textAlign: TextAlign.center,
                                              ),
                                              VSpace.lg,
                                              AspectRatio(
                                                aspectRatio: 16 /
                                                    9, // Set aspect ratio for the image
                                                child: ClipRRect(
                                                  borderRadius:
                                                      Corners.lgBorder,
                                                  child: Image(
                                                    image: NetworkImage(
                                                        spots[index].image),
                                                    fit: BoxFit
                                                        .cover, // Use BoxFit.cover to cover the full space
                                                  ),
                                                ),
                                              ),
                                              VSpace.med,
                                              Text(
                                                spots[index].name,
                                                style: TextStyles.h2
                                                    .copyWith(fontSize: 32),
                                                textAlign: TextAlign.center,
                                              ),
                                              VSpace.lg,
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Cost: ${spots[index].ratePerHr}/hour",
                                                      style: TextStyles.body1,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (!widget.isHost) ...[
                                                const Spacer(),
                                                ParkMateButton(
                                                    onTap: isLoading
                                                        ? null
                                                        : () async {
                                                            TimeOfDay
                                                                startTime =
                                                                TimeOfDay.now();
                                                            int duration =
                                                                60; // 1 hour
                                                            // show a dialog which has the time picker such as 12:00 PM (Time picker)
                                                            bool doReserve =
                                                                await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return StatefulBuilder(builder:
                                                                            (context,
                                                                                customState) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const Text('Select Time'),
                                                                            content:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                const Text('Select the time you want to reserve the spot for'),
                                                                                const SizedBox(height: 20),
                                                                                Row(
                                                                                  children: [
                                                                                    const Text('Start Time: '),
                                                                                    const SizedBox(width: 20),
                                                                                    ElevatedButton(
                                                                                      onPressed: () async {
                                                                                        // show time picker
                                                                                        startTime = await showTimePicker(context: context, initialTime: startTime) ?? startTime;
                                                                                        customState(() {});
                                                                                      },
                                                                                      child: Text(startTime.format(context)),
                                                                                    ),
                                                                                  ],
                                                                                ),
// duration (1 hour, 2 hours, 3 hours.. max 24 hours) dropdown
                                                                                const SizedBox(height: 20),
                                                                                Row(
                                                                                  children: [
                                                                                    const Text('Duration: '),
                                                                                    const SizedBox(width: 20),
                                                                                    DropdownButton<int>(
                                                                                      value: 1,
                                                                                      onChanged: (value) {
                                                                                        duration = 60 * (value ?? 1);
                                                                                        customState(() {});
                                                                                      },
                                                                                      items: List.generate(24, (index) {
                                                                                        return DropdownMenuItem<int>(
                                                                                          value: index + 1,
                                                                                          child: Text('${index + 1}'),
                                                                                        );
                                                                                      }),
                                                                                    ),
                                                                                    const Text(' hour(s)'),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text('Cancel'),
                                                                              ),
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context, true);
                                                                                },
                                                                                child: const Text('Reserve'),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        });
                                                                      },
                                                                    ) ??
                                                                    false;
                                                            if (!doReserve)
                                                              return;
                                                            isLoading = true;
                                                            setState(() {});
                                                            bool success =
                                                                await reserveSpot(
                                                                    context,
                                                                    spots[
                                                                        index],
                                                                    duration,
                                                                    startTime);
                                                            isLoading = false;
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context);
                                                            if (!success)
                                                              return;

                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const ParkingConfirmation()));
                                                          },
                                                    text: isLoading
                                                        ? "Reserving Spot"
                                                        : "Reserve Spot"),
                                              ],
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.location_pin,
                                    size: 60, color: Colors.black),
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                // add a text widget to show the current location
                Positioned(
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(Insets.sm),
                    color: theme.scaffoldBackgroundColor,
                    child: Text("Your Area: $locationName"),
                  ),
                ),
              ],
            ),
    );
  }
}
