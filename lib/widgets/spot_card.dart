import 'package:flutter/material.dart';
import 'package:parkmate/constants/colors.dart';
import 'package:parkmate/models/spot.dart';
import 'package:parkmate/spot_seaker/spot_details_view.dart';
import 'package:parkmate/widgets/custom_rounded_image.dart';
import 'package:parkmate/widgets/styled_spacers.dart';
import 'package:parkmate/widgets/styles.dart';

class SpotCard extends StatelessWidget {
  const SpotCard({
    super.key,
    required this.theme,
    required this.spot,
    this.isHost = false,
  });

  final ThemeData theme;
  final Spot spot;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SpotDetailsView(isHost: isHost, spot: spot)));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRoundedImage(image: spot.image),
            VSpace.sm,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.xs * 1.5),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: kPrimary,
                      borderRadius: Corners.xlBorder,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Insets.med),
                    child: Text(
                      "${spot.discount}% OFF",
                      style: TextStyles.body1.copyWith(
                          fontSize: 10, color: theme.colorScheme.surface),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  HSpace.lg,
                  Container(
                    decoration: const BoxDecoration(
                      color: kPrimary,
                      borderRadius: Corners.xlBorder,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Insets.med),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 8,
                        ),
                        HSpace.xs,
                        Text(
                          spot.rating.toString(),
                          style: TextStyles.body1.copyWith(
                              fontSize: 10, color: theme.colorScheme.surface),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
              child: Text(
                spot.name,
                style: TextStyles.body2
                    .copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
              child: Text(
                "\$${spot.ratePerHr}/hr",
                style: TextStyles.body1.copyWith(fontSize: 14.0),
              ),
            ),
            VSpace.sm,
          ],
        ),
      ),
    );
  }
}
