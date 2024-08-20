import 'package:flutter/material.dart';
import 'package:parkmate/widgets/custom_rounded_image.dart';
import 'package:parkmate/widgets/styled_spacers.dart';

class SpotListCard extends StatelessWidget {
  const SpotListCard(
      {super.key,
      required this.image,
      required this.spotName,
      required this.bookingDate,
      required this.amount,
      required this.rate});

  final String image;
  final String spotName;
  final String bookingDate;
  final String amount;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CustomRoundedImage(
          aspectRatio: 1.2,
          image: image,
        ),
        title: Text(spotName),
        subtitle: Text('Booking Date: ' + bookingDate),
        trailing: Column(
          children: [Text(amount), VSpace.lg, Text(rate)],
        ),
      ),
    );
  }
}
