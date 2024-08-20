import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parkmate/commands/firebase_analytics.dart';
import 'package:parkmate/providers/app_provider.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class SpotSeekerProfile extends StatefulWidget {
  const SpotSeekerProfile({super.key});

  @override
  State<SpotSeekerProfile> createState() => _SpotSeekerProfileState();
}

class _SpotSeekerProfileState extends State<SpotSeekerProfile> {
  ScreenshotController screenshotController = ScreenshotController();

  void share() async {
    AnalyticsCommand.logEvent('share_savings');
    final image = await screenshotController.captureFromWidget(SizedBox(
      width: 400,
      height: 260,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.share,
                    size: 22,
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: Image(
                        height: 50,
                        image: AssetImage("assets/images/Logo.png")),
                  ),
                  Icon(
                    Icons.share,
                    size: 22,
                    color: Colors.transparent,
                  ),
                ],
              ),
              Text(
                "Total Savings",
                style: TextStyles.h3.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              VSpace.xs,
              Text(
                "\$17.1",
                style: TextStyles.h3.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              VSpace.med,
              Text(
                "This is eqvivalent to 10 Litres of gasoline saved",
                style: TextStyles.body1.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              VSpace.med,
              const Image(
                  height: 50,
                  image: AssetImage("assets/images/GooglePlay.png")),
            ],
          ),
        ),
      ),
    ));

    final directory = (await getApplicationDocumentsDirectory()).path;
    final imagePath = await File('$directory/image.png').create();
    await imagePath.writeAsBytes(image);

    XFile xFile = XFile(imagePath.path);

    await Share.shareXFiles([xFile],
        text:
            "Check out my fuel savings through ParkMate app. Start saving fuel and money by using ParkMate to find parking spot easily. Pre-register now!\nhttps://dalu-my.sharepoint.com/:f:/g/personal/am839007_dal_ca/EtSLrShgLX1IjUIbPkUNh90BjHhCj0d4WCUD8hylYQIZtg?e=ly2d6e");
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
        children: [
          Text(
            "Welcome, $name",
            style: TextStyles.h2.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          VSpace.lg,
          SizedBox(
            width: 400,
            // height: 200,
            child: GestureDetector(
              onTap: share,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 22,
                            color: Colors.transparent,
                          ),
                          Expanded(
                            child: Image(
                                height: 50,
                                image: AssetImage("assets/images/Logo.png")),
                          ),
                          Icon(
                            Icons.share,
                            size: 22,
                          ),
                        ],
                      ),
                      Text(
                        "Total Savings",
                        style: TextStyles.h3.copyWith(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      VSpace.xs,
                      Text(
                        "\$17.1",
                        style: TextStyles.h3.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      VSpace.med,
                      Text(
                        "This is eqvivalent to 10 Litres of gasoline saved",
                        style: TextStyles.body1.copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      // VSpace.med,
                      // const Image(
                      //     height: 50,
                      //     image: AssetImage("assets/images/GooglePlay.png")),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ))));
  }
}
