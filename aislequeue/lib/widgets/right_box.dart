import 'package:flutter/material.dart';

class RightBox extends StatelessWidget {
  final double bottom;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;

  const RightBox({
    Key? key,
    required this.bottom,
    this.left,
    this.right,
    this.height = 60,
    this.width = 30,
    this.color = const Color(0xff5A967A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}
