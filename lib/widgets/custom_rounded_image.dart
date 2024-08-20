import 'package:flutter/material.dart';
import 'package:parkmate/widgets/styles.dart';

class CustomRoundedImage extends StatelessWidget {
  const CustomRoundedImage({
    super.key,
    required this.image,
    this.aspectRatio,
  });

  final String image;
  final double? aspectRatio;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio ?? 16 / 9, // Set aspect ratio for the image
      child: ClipRRect(
        borderRadius: Corners.lgBorder,
        child: Image(
          image: NetworkImage(image),
          fit: BoxFit.cover, // Use BoxFit.cover to cover the full space
        ),
      ),
    );
  }
}
