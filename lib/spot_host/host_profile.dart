import 'package:flutter/material.dart';
import 'package:parkmate/auth/login_view.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/spot_host/commands/get_total_earnings.dart';
import 'package:parkmate/spot_seaker/booking_history.dart';
import 'package:parkmate/widgets/park_mate_button.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';
import 'package:provider/provider.dart';

class HostProfile extends StatefulWidget {
  const HostProfile({super.key});

  @override
  State<HostProfile> createState() => _HostProfileState();
}

class _HostProfileState extends State<HostProfile> {
  bool isLoading = false;
  int totalEarnings = 0;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    isLoading = true;
    setState(() {});

    totalEarnings = await getTotalEarnings(context);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final String name = context.read<AppProvider>().user?.name ?? "Guest";
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, $name",
                style: TextStyles.h2.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              VSpace.lg,
              Text(
                "Total Earnings",
                style: TextStyles.h3.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              VSpace.med,
              Text(
                isLoading ? "Calculating..." : "\$$totalEarnings",
                style: TextStyles.h3.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              ParkMateButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookingHistory(
                                isHost: true,
                              )),
                    );
                  },
                  text: "View current bookings"),
              VSpace.lg,
              // Add other functionalities in button.
              ParkMateButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  },
                  text: "Logout"),
            ],
          ),
        ),
      ),
    ));
  }
}
