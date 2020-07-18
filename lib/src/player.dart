import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/joystick/joystick_component.dart';
import 'package:flame/components/joystick/joystick_events.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

import 'goods.dart';

class Player extends PositionComponent implements JoystickListener {
  final _whitePaint = Paint()..color = Colors.pink[100];
  final double speed = 159;
  double currentSpeed = 0;
  double radAngle = 0;
  bool _move = false;
  Paint _paint;

  Rect _rect;
  Set<Goods> _goodsInVision = {};
  Goods _goodsHeld;

  final Size screenSize;

  Player(this.screenSize) {
    _paint = _whitePaint;
  }

  @override
  void render(Canvas canvas) {
    if (_rect != null) {
      canvas.save();
      canvas.translate(_rect.center.dx, _rect.center.dy);
      canvas.rotate(radAngle == 0.0 ? 0.0 : radAngle + (pi / 2));
      canvas.translate(-_rect.center.dx, -_rect.center.dy);
      canvas.drawRect(_rect, _paint);
      canvas.restore();
    }
  }

  @override
  void update(double dt) {
    if (_move) {
      moveFromAngle(dt);
    }
  }

  @override
  void resize(Size size) {
    _rect = Rect.fromLTWH(
      (size.width / 2) - 25,
      (size.height / 2) - 25,
      50,
      50,
    );
    super.resize(size);
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN) {
      if (event.id == 1) {
        _goodsHeld = _goodsInVision.first;
      }
      if (event.id == 2) {
        _goodsHeld = null;
      }
    }
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    _move = event.directional != JoystickMoveDirectional.IDLE;
    if (_move) {
      radAngle = event.radAngle;
      currentSpeed = speed * event.intensity;
    }
  }

  void moveFromAngle(double dtUpdate) {
    final double nextX = (currentSpeed * dtUpdate) * cos(radAngle);
    final double nextY = (currentSpeed * dtUpdate) * sin(radAngle);
    final Offset nextPoint = Offset(nextX, nextY);

    final Offset diffBase = Offset(
          _rect.center.dx + nextPoint.dx,
          _rect.center.dy + nextPoint.dy,
        ) -
        _rect.center;

    final Rect newPosition = _rect.shift(diffBase);

    if (newPosition.left > 0 &&
        newPosition.top > 0 &&
        newPosition.right < screenSize.width &&
        newPosition.bottom < screenSize.height) {
      _rect = newPosition;
      if (_goodsHeld != null) {
        _goodsHeld.setByPosition(Position(_rect.left, _rect.top));
      }
    }
  }

  bool collided(PositionComponent component) {
    if (_rect == null) return false;
    return _rect.overlaps(component.toRect());
  }

  void addGoodsInVision(Goods goods) {
    _goodsInVision.add(goods);
  }

  void removeGoodsInVision(Goods goods) {
    if (_goodsInVision.contains(goods)) {
      _goodsInVision.remove(goods);
    }
  }
}
