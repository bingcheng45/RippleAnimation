import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RipplePainter extends CustomPainter {
  final Offset center;
  final double radius, containerHeight;
  final BuildContext context;

  Color color;
  double statusBarHeight, screenWidth;

  RipplePainter(
      {this.context, this.containerHeight, this.center, this.radius}) {
    
    color = Colors.white38;
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double regionHeight = containerHeight + statusBarHeight;
    double regionWidth = screenWidth;
    double screenHeight = MediaQuery.of(context).size.height;

    Paint circlePainter = Paint();

    circlePainter.color = color;

    //canvas.clipRect(Rect.fromLTWH(0, 0, regionWidth, regionHeight)); //seems optional for now
    canvas.drawCircle(center, radius, circlePainter);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(RipplePainter oldDelegate) => true;
}
