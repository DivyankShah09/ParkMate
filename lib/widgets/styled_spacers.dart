import 'package:flutter/cupertino.dart';
import 'package:parkmate/widgets/styles.dart';

class Space extends StatelessWidget {
  final double width;
  final double height;

  const Space(this.width, this.height, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: width, height: height);
}

class VSpace extends StatelessWidget {
  final double size;

  const VSpace(this.size, {super.key});

  @override
  Widget build(BuildContext context) => Space(0, size);

  static const VSpace xs = VSpace(Insets.xs);
  static const VSpace sm = VSpace(Insets.sm);
  static const VSpace med = VSpace(Insets.med);
  static const VSpace lg = VSpace(Insets.lg);
  static const VSpace xl = VSpace(Insets.xl);
  static const Expanded max = Expanded(child: VSpace(Insets.xs));
}

class HSpace extends StatelessWidget {
  final double size;

  const HSpace(this.size, {super.key});

  @override
  Widget build(BuildContext context) => Space(size, 0);

  static const HSpace xs = HSpace(Insets.xs);
  static const HSpace sm = HSpace(Insets.sm);
  static const HSpace med = HSpace(Insets.med);
  static const HSpace lg = HSpace(Insets.lg);
  static const HSpace xl = HSpace(Insets.xl);
  static const Expanded max = Expanded(child: VSpace(Insets.xs));
}
