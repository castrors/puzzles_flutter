import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'src/game.dart';

void main() async {
  Size size = await Flame.util.initialDimensions();
  final game = Game(size);
  runApp(game.widget);
}
