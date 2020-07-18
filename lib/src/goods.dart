import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';

class Goods extends PositionComponent {
  Color color;
  Goods(double x, double y, Color color) {
    this.x = x;
    this.y = y;
    this.width = 28;
    this.height = 28;
    this.color = color;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(toRect(), Paint()..color = color);
  }

  @override
  void update(double dt) {}
}
