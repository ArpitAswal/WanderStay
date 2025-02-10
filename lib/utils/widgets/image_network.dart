import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class ImageNetwork extends StatelessWidget {
  const ImageNetwork(this.color,
      {super.key, required this.src, required this.errorIcon});
  final Color? color;
  final String src;
  final Icon errorIcon;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src,
      fit: BoxFit.cover,
      color: color,
      filterQuality: FilterQuality.high,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
        Center(child: CircularProgressIndicator(color: AppColors.darkPinkColor, value: downloadProgress.progress)),
      errorWidget: (context, url, error) => errorIcon,
    );
  }
}
