import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkmate/constants/colors.dart';
import 'package:parkmate/constants/string.dart';
import 'package:parkmate/models/spot.dart';
import 'package:parkmate/spot_seaker/commands/reserve_spot_command.dart';
import 'package:parkmate/spot_seaker/parking_confirmation.dart';
import 'package:parkmate/widgets/park_mate_button.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';

class SpotDetailsView extends StatefulWidget {
  const SpotDetailsView({super.key, required this.spot, required this.isHost});
  final Spot spot;
  final bool isHost;

  @override
  State<SpotDetailsView> createState() => _SpotDetailsViewState();
}

class _SpotDetailsViewState extends State<SpotDetailsView> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Insets.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.spot.name,
                          style: TextStyles.h1.copyWith(fontSize: 28.0),
                        ),
                      ),
                      VSpace.med,
                      Center(
                        child: ClipRRect(
                          borderRadius: Corners.lgBorder,
                          child: Image.network(
                            widget.spot.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      VSpace.med,
                      Text(
                        'Location',
                        style: TextStyles.h2,
                      ),
                      VSpace.xs,
                      // icon + location
                      Row(
                        children: [
                          const Icon(CupertinoIcons.location_fill),
                          HSpace.sm,
                          Expanded(
                            child: Text(
                              widget.spot.location,
                              style: TextStyles.title1.copyWith(
                                  // overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      VSpace.med,
                      Text(
                        'Facilities',
                        style: TextStyles.h2,
                      ),
                      VSpace.xs,
                      Wrap(
                        spacing: Insets.sm,
                        runSpacing: Insets.xs,
                        children: widget.spot.facilities
                            .map((facility) => Chip(
                                  color: WidgetStateProperty.all(kSecondary),
                                  label: Text(
                                    facility,
                                    style: const TextStyle(color: kPrimary),
                                  ),
                                ))
                            .toList(),
                      ),
                      VSpace.med,
                      Text(
                        'Timing Availability',
                        style: TextStyles.h2,
                      ),
                      VSpace.xs,
                      // table having days on left and time on right
                      ...List.generate(days.length, (index) {
                        return Row(
                          children: [
                            Text(
                              days[index],
                              style: TextStyles.title1,
                            ),
                            const Spacer(),
                            Text(
                              '10:00 AM - 6:00 PM',
                              style: TextStyles.title1,
                            ),
                            HSpace.xl,
                          ],
                        );
                      }),
                      VSpace.med,
                      Text(
                        'Rate per hour',
                        style: TextStyles.h2,
                      ),
                      VSpace.xs,
                      Text(
                        '\$ ${widget.spot.ratePerHr}',
                        style: TextStyles.title1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            VSpace.med,
            if (!widget.isHost)
              ParkMateButton(
                  onTap: isLoading
                      ? null
                      : () async {
                          TimeOfDay startTime = TimeOfDay.now();
                          int duration = 60; // 1 hour
                          // show a dialog which has the time picker such as 12:00 PM (Time picker)
                          bool doReserve = await showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, customState) {
                                    return AlertDialog(
                                      title: const Text('Select Time'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                              'Select the time you want to reserve the spot for'),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              const Text('Start Time: '),
                                              const SizedBox(width: 20),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  // show time picker
                                                  startTime =
                                                      await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  startTime) ??
                                                          startTime;
                                                  customState(() {});
                                                },
                                                child: Text(
                                                    startTime.format(context)),
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
                                                value: duration ~/ 60,
                                                onChanged: (value) {
                                                  duration = 60 * (value ?? 1);
                                                  customState(() {});
                                                },
                                                items:
                                                    List.generate(12, (index) {
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
                          if (!doReserve) return;
                          isLoading = true;
                          setState(() {});
                          bool success = await reserveSpot(
                              context, widget.spot, duration, startTime);
                          isLoading = false;
                          setState(() {});
                          if (!success) return;
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ParkingConfirmation()));
                        },
                  text: isLoading
                      ? 'Reserving spot...'
                      : 'Reserve Spot for 1 hour'),
            VSpace.med,
          ],
        ),
      )),
    );
  }
}
