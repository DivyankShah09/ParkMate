import 'package:flutter/material.dart';
import 'package:parkmate/constants/colors.dart';
import 'package:parkmate/spot_seaker/dashboard_seeker.dart';
import 'package:parkmate/widgets/park_mate_button.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';

class ParkingConfirmation extends StatelessWidget {
  const ParkingConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage("assets/images/ParkingConfirmation.png")),
              const VSpace(Insets.lg * 1.5),
              Text(
                "Your parking spot is confirmed.",
                style: TextStyles.h3.copyWith(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              const VSpace(Insets.lg * 1.5),
              Text(
                "Thank you for using ParkMate.",
                style: TextStyles.h3.copyWith(fontSize: 24.0, color: kGrey),
                textAlign: TextAlign.center,
              ),
              VSpace.lg,
              ParkMateButton(
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const DashboardSeeker()));
                  },
                  text: "Home"),
            ],
          ),
        ),
      ),
    );
  }
}
