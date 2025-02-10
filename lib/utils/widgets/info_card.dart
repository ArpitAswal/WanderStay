
import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(this.icon, this.name, {super.key, required this.tap});
  final void Function() tap;
  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
      return InkWell(
        onTap: tap,
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 8.0,
          shadowColor: AppColors.blackColor,
          margin: const EdgeInsets.only(bottom: 12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(icon),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Expanded(
                  child: Text(name),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      );
    }
}
