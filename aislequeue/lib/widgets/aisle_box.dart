import 'package:flutter/material.dart';

class AisleBox extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double height;
  final double width;
  final Color color;

  const AisleBox({
    Key? key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.height = 20,
    this.width = 130,
    this.color = const Color(0xff5A967A),
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
        color: color,
      ),
    );
  }
}
