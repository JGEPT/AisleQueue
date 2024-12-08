import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CircleNum extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;
  final String number;

  const CircleNum({
    Key? key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.height = 30,
    this.width = 30,
    this.color = const Color(0xff006769),
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              color: AppColors.circleTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
