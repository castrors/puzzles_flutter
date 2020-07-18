
import 'package:flame/components/joystick/joystick_action.dart';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_directional.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';

import 'package:flutter/material.dart';

import 'corn.dart';
import 'fox.dart';
import 'goods.dart';
import 'goose.dart';
import 'player.dart';

class Game extends BaseGame with MultiTouchDragDetector {
  final Size size;
  Player player;
  final joystick = JoystickComponent(
    directional: JoystickDirectional(),
    actions: [
      JoystickAction(
        actionId: 1,
        size: 50,
        margin: const EdgeInsets.all(50),
        color: Colors.blue,
      ),
      JoystickAction(
        actionId: 2,
        size: 50,
        color: Colors.green,
        margin: const EdgeInsets.only(
          right: 120,
          bottom: 50,
        ),
      ),
    ],
  );

  Game(this.size) {
    player = Player(size);
    final goose = Goose(50, 50);
    final fox = Fox(120, 50);
    final corn = Corn(170, 50);
    joystick.addObserver(player);
    add(player);
    add(goose);
    add(fox);
    add(corn);
    add(joystick);
  }

  @override
  void update(double t) {
    super.update(t);

    components.forEach((element) {
      if (element is Goods) {
        if (player.collided(element)) {
          player.addGoodsInVision(element);
        } else {
          player.removeGoodsInVision(element);
        }
      }
    });
  }

  @override
  void onReceiveDrag(DragEvent drag) {
    joystick.onReceiveDrag(drag);
    super.onReceiveDrag(drag);
  }
}
