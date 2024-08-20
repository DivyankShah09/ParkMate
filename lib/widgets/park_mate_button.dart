import 'package:flutter/material.dart';
import 'package:parkmate/constants/colors.dart';
import 'package:parkmate/widgets/styles.dart';

class ParkMateButton extends StatelessWidget {
  const ParkMateButton({
    super.key,
    required this.onTap,
    required this.text,
    this.buttonColor,
    this.textColor,
    this.isEnabled = true,
  });

  final void Function()? onTap;
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: double.maxFinite,
          height: 50,
          decoration: BoxDecoration(
            color: !isEnabled
                ? kPrimary.withOpacity(0.4)
                : buttonColor ?? kPrimary,
            borderRadius: Corners.medBorder,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? theme.colorScheme.surface,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
