import 'package:flutter/material.dart';

class LeftBox extends StatelessWidget {
  final double top;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;

  const LeftBox({
    Key? key,
    required this.top,
    this.left,
    this.right,
    this.height = 45,
    this.width = 30,
    this.color = const Color(0xff5A967A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
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
