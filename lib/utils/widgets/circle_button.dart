import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final double? radius;
  final Color? color;
  final Color? iconColor;

  const CircleButton({
    super.key,
    required this.icon,
    required this.radius,
    this.color = AppColors.lightPinkColor,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
