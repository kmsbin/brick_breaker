import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Brick {
  double x;
  double y;
  double size;
  double height;
  Color color;

  Brick({this.x, this.y, this.size, this.color, this.height});

  void drawBrick(Canvas ctx) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    ctx.drawRect(
      Rect.fromLTRB(x, y, x + size, y + height),
      paint,
    );
  }
}
