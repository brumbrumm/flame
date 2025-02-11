import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../../commons/square_component.dart';

final green = Paint()..color = const Color(0xAA338833);

class SequenceEffectExample extends FlameGame with TapDetector {
  static const String description = '''
    In this example we show how different effects can be chained in the
    `SequenceEffect`. Click anywhere on the screen to start the effects
    sequence.
  ''';

  late SquareComponent greenSquare;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    greenSquare = SquareComponent(position: Vector2.all(100), paint: green);
    add(greenSquare);
  }

  @override
  void onTapUp(TapUpInfo info) {
    final currentTap = info.eventPosition.game;
    greenSquare.clearEffects();

    final move = MoveEffect(
      path: [
        currentTap,
        currentTap + Vector2(-20, 50),
        currentTap + Vector2(-50, -50),
        currentTap + Vector2(50, 0),
      ],
      speed: 150.0,
      curve: Curves.easeIn,
    );

    final size = SizeEffect(
      size: currentTap - greenSquare.position,
      speed: 100.0,
      curve: Curves.easeInCubic,
    );

    final rotate = RotateEffect(
      angle: currentTap.angleTo(Vector2.all(100)),
      duration: 0.8,
      curve: Curves.decelerate,
    );

    final sequence = SequenceEffect(
      effects: [size, rotate, move],
      isAlternating: true,
    );
    sequence.onComplete = () => print('sequence complete');
    greenSquare.add(sequence);
  }
}
