import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget assetImage(
  String path, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  BorderRadius? borderRadius,
  bool circle = false,
}) {
  final isSvg = path.toLowerCase().endsWith('.svg');
  Widget image = isSvg
      ? SvgPicture.asset(path, width: width, height: height, fit: fit)
      : Image.asset(path, width: width, height: height, fit: fit);

  if (circle) {
    return ClipOval(child: image);
  }
  if (borderRadius != null) {
    return ClipRRect(borderRadius: borderRadius, child: image);
  }
  return image;
}


