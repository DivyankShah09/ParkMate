import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:parkmate/commands/firebase_analytics.dart';
import 'package:parkmate/commands/upload_images.dart';
import 'package:parkmate/providers/spot_host_provider.dart';
import 'package:parkmate/spot_host/commands/add_spot.dart';
import 'package:parkmate/widgets/custom_text_field.dart';
import 'package:parkmate/widgets/park_mate_button.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';
import 'package:provider/provider.dart';

class AddSpot extends StatefulWidget {
  const AddSpot({super.key});

  @override
  State<AddSpot> createState() => _AddSpotState();
}

class _AddSpotState extends State<AddSpot> {
  bool isLoading = false;
  bool isGettingLocation = false;
  bool isUploadingImage = false;
  LocationData? locationData;
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  final double latitude = 44.651070;
  final double longitude = -63.582687;

  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AnalyticsCommand.logScreenView("Add Spot View");
    initLocation();
  }

  void initLocation() async {
    isGettingLocation = true;
    setState(() {});
    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        isGettingLocation = false;
        setState(() {});
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        isGettingLocation = false;
        setState(() {});
        return;
      }
    }

    locationData = await location.getLocation();
    print(
        "Location detected: ${locationData?.latitude}, ${locationData?.longitude}");
    List<geocode.Placemark> placemarks = await geocode.placemarkFromCoordinates(
        locationData?.latitude ?? latitude,
        locationData?.longitude ?? longitude);
    isGettingLocation = false;

    context
        .read<SpotHostProvider>()
        .setAddressLine1(placemarks[0].street.toString());

    context.read<SpotHostProvider>().setCity(placemarks[0].locality.toString());
    context
        .read<SpotHostProvider>()
        .setProvince(placemarks[0].administrativeArea.toString());
    context
        .read<SpotHostProvider>()
        .setPinCode(placemarks[0].postalCode.toString());
    context.read<SpotHostProvider>().setLatitude(locationData?.latitude ?? 0);
    context.read<SpotHostProvider>().setLongitude(locationData?.longitude ?? 0);

    addressLine1Controller.text = placemarks[0].street.toString();
    cityController.text = placemarks[0].locality.toString();
    provinceController.text = placemarks[0].administrativeArea.toString();
    pinCodeController.text = placemarks[0].postalCode.toString();
    latitudeController.text = locationData?.latitude.toString() ?? '';
    longitudeController.text = locationData?.longitude.toString() ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String image = context.select((SpotHostProvider p) => p.image);
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Register a Spot",
                      style: TextStyles.h2.copyWith(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    VSpace.lg,
                    CustomTextField(
                        onChange: (value) {
                          context.read<SpotHostProvider>().setName(value);
                        },
                        label: 'Name',
                        validator:
                            context.read<SpotHostProvider>().validateName,
                        hintText: 'Enter Name'),
                    VSpace.lg,
                    CustomTextField(
                        isLoading: isGettingLocation,
                        controller: addressLine1Controller,
                        onChange: (value) {
                          context
                              .read<SpotHostProvider>()
                              .setAddressLine1(value);
                        },
                        label: 'Address Line 1',
                        validator:
                            context.read<SpotHostProvider>().validateAddress,
                        hintText: 'Enter Address Line 1'),
                    VSpace.lg,
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                              controller: cityController,
                              onChange: (value) {
                                context.read<SpotHostProvider>().setCity(value);
                              },
                              label: 'City',
                              validator:
                                  context.read<SpotHostProvider>().validateCity,
                              hintText: 'Enter City'),
                        ),
                        HSpace.med,
                        Expanded(
                          child: CustomTextField(
                              controller: provinceController,
                              onChange: (value) {
                                context
                                    .read<SpotHostProvider>()
                                    .setProvince(value);
                                setState(() {});
                              },
                              label: 'Province',
                              validator: context
                                  .read<SpotHostProvider>()
                                  .validateProvince,
                              hintText: 'Enter Province'),
                        ),
                      ],
                    ),
                    VSpace.lg,
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                              controller: pinCodeController,
                              onChange: (value) {
                                context
                                    .read<SpotHostProvider>()
                                    .setPinCode(value);
                              },
                              label: 'Pin Code',
                              validator: context
                                  .read<SpotHostProvider>()
                                  .validatePinCode,
                              hintText: 'Enter Pin Code'),
                        ),
                        HSpace.med,
                        Expanded(
                          child: CustomTextField(
                              keyboardType: TextInputType.number,
                              onChange: (value) {
                                if (value.isNotEmpty) {
                                  context
                                      .read<SpotHostProvider>()
                                      .setRatePerHour(int.parse(value));
                                }
                                setState(() {});
                              },
                              label: 'Rate per hour',
                              validator: (v) {
                                if (v == null) return null;
                                if (v.isEmpty)
                                  return 'Rate per hour is required';
                                return context
                                    .read<SpotHostProvider>()
                                    .validateRatePerHour(int.parse(v));
                              },
                              hintText: 'Enter Rate per hour'),
                        ),
                      ],
                    ),
                    VSpace.lg, // email input
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                              isLoading: isGettingLocation,
                              controller: latitudeController,
                              onChange: (value) {
                                context
                                    .read<SpotHostProvider>()
                                    .setLatitude(double.parse(value));
                              },
                              label: 'Latitude',
                              validator: (value) => context
                                  .read<SpotHostProvider>()
                                  .validateLatitudeLongitude(
                                      double.parse(value ?? '')),
                              hintText: 'Enter Latitude'),
                        ),
                        HSpace.med,
                        Expanded(
                          child: CustomTextField(
                              isLoading: isGettingLocation,
                              controller: longitudeController,
                              onChange: (value) {
                                context
                                    .read<SpotHostProvider>()
                                    .setLongitude(double.parse(value));
                              },
                              label: 'Longitude',
                              validator: (value) => context
                                  .read<SpotHostProvider>()
                                  .validateLatitudeLongitude(
                                      double.parse(value ?? '')),
                              hintText: 'Enter Longitude'),
                        ),
                      ],
                    ),
                    VSpace.lg,
                    Text(
                      isGettingLocation
                          ? "Getting your location..."
                          : "Note: The latitude and longitude fields are automatically filled based on your current location. You can manually enter the values if you want to register a spot at a different location.",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    VSpace.lg,
                    // select image placeholder
                    if (image.isEmpty)
                      GestureDetector(
                        onTap: () async {
                          isUploadingImage = true;
                          setState(() {});
                          // pick image
                          ImagePicker imagePicker = ImagePicker();
                          XFile? imageData = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (imageData != null) {
                            Uint8List data = await imageData.readAsBytes();
                            // upload image
                            String? imageUrl =
                                await uploadImageToS3(data, imageData.name);
                            context
                                .read<SpotHostProvider>()
                                .setImage(imageUrl ?? '');
                          }
                          isUploadingImage = false;
                          setState(() {});
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(Corners.med),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isUploadingImage
                                  ? const CircularProgressIndicator()
                                  : const Icon(Icons.image,
                                      size: 48, color: Colors.grey),
                              Center(
                                child: Text(
                                  "Select Image",
                                  style: theme.textTheme.bodyLarge
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (image.isEmpty)
                      Text("Image not selected",
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.red)),

                    if (image.isNotEmpty)
                      SizedBox(
                        // give image a height in 16:9 aspect ratio
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Corners.med),
                          child: Image.network(
                              context.read<SpotHostProvider>().image),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            VSpace.lg,
            ParkMateButton(
                isEnabled: context
                        .read<SpotHostProvider>()
                        .validateSpotRegistrationForm() &&
                    !isLoading &&
                    !isGettingLocation,
                onTap: () async {
                  if (context
                      .read<SpotHostProvider>()
                      .validateSpotRegistrationForm()) {
                    isLoading = true;
                    setState(() {});
                    await addSpot(context);
                    isLoading = false;
                    setState(() {});
                  } else {
                    print('Spot registration form is invalid');
                  }
                },
                text: "Add Spot")
          ],
        ),
      ),
    ));
  }
}
