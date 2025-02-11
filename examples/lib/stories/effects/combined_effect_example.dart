import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../../commons/square_component.dart';

final green = Paint()..color = const Color(0xAA338833);
final red = Paint()..color = const Color(0xAA883333);

class CombinedEffectExample extends FlameGame with TapDetector {
  static const String description = '''
    In this example we show how multiple effects can be combined into one effect
    with the `CombinedEffect`. Click anywhere on the screen to run the effect.
  ''';

  late SquareComponent greenSquare, redSquare;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    greenSquare = SquareComponent(position: Vector2.all(100), paint: green);
    redSquare = SquareComponent(position: Vector2.all(100), paint: red);

    add(greenSquare);
    add(redSquare);
  }

  @override
  void onTapUp(TapUpInfo info) {
    greenSquare.clearEffects();
    final currentTap = info.eventPosition.game;

    final move = MoveEffect(
      path: [
        currentTap,
        currentTap + Vector2(-20, 50),
        currentTap + Vector2(-50, -50),
        currentTap + Vector2(50, 0),
      ],
      isAlternating: true,
      duration: 4.0,
      curve: Curves.bounceInOut,
      initialDelay: 0.6,
    );

    final scale = SizeEffect(
      size: currentTap,
      speed: 200.0,
      curve: Curves.linear,
      isAlternating: true,
      peakDelay: 1.0,
    );

    final rotate = RotateEffect(
      angle: currentTap.angleTo(Vector2.all(100)),
      duration: 3,
      curve: Curves.decelerate,
      isAlternating: true,
      initialDelay: 1.0,
      peakDelay: 1.0,
    );

    final combination = CombinedEffect(
      effects: [move, rotate, scale],
    );
    greenSquare.add(combination);
  }
}
