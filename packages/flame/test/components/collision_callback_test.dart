import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame_test/flame_test.dart';
import 'package:test/test.dart';

class _HasCollidablesGame extends FlameGame with HasCollidables {}

class _TestHitbox extends HitboxRectangle {
  final Set<HitboxShape> collisions = {};
  int endCounter = 0;

  _TestHitbox() {
    onCollision = (_, shape) => collisions.add(shape);
    onCollisionEnd = (shape) {
      endCounter++;
      collisions.remove(shape);
    };
  }

  bool hasCollisionWith(HitboxShape otherShape) {
    return collisions.contains(otherShape);
  }
}

class _TestBlock extends PositionComponent with HasHitboxes, Collidable {
  final Set<Collidable> collisions = {};
  final hitbox = _TestHitbox();
  int endCounter = 0;

  _TestBlock(Vector2 position, Vector2 size)
      : super(
          position: position,
          size: size,
        ) {
    addHitbox(hitbox);
  }

  bool hasCollisionWith(Collidable otherCollidable) {
    return collisions.contains(otherCollidable);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    collisions.add(other);
  }

  @override
  void onCollisionEnd(Collidable other) {
    endCounter++;
    collisions.remove(other);
  }
}

void main() {
  final withCollidables = FlameTester(() => _HasCollidablesGame());

  group('Collision callbacks', () {
    withCollidables.test('collidable callbacks are called', (game) async {
      final blockA = _TestBlock(
        Vector2.zero(),
        Vector2.all(10),
      );
      final blockB = _TestBlock(
        Vector2.all(1),
        Vector2.all(10),
      );
      await game.ensureAddAll([blockA, blockB]);
      expect(blockA.hasCollisionWith(blockB), true);
      expect(blockB.hasCollisionWith(blockA), true);
      expect(blockA.collisions.length, 1);
      expect(blockB.collisions.length, 1);
      blockB.position = Vector2.all(21);
      expect(blockA.endCounter, 0);
      expect(blockB.endCounter, 0);
      game.update(0);
      expect(blockA.hasCollisionWith(blockB), false);
      expect(blockB.hasCollisionWith(blockA), false);
      expect(blockA.collisions.length, 0);
      expect(blockB.collisions.length, 0);
      game.update(0);
      expect(blockA.endCounter, 1);
      expect(blockB.endCounter, 1);
    });

    withCollidables.test('hitbox callbacks are called', (game) async {
      final blockA = _TestBlock(
        Vector2.zero(),
        Vector2.all(10),
      );
      final blockB = _TestBlock(
        Vector2.all(1),
        Vector2.all(10),
      );
      final hitboxA = blockA.hitbox;
      final hitboxB = blockB.hitbox;
      await game.ensureAddAll([blockA, blockB]);
      expect(hitboxA.hasCollisionWith(hitboxB), true);
      expect(hitboxB.hasCollisionWith(hitboxA), true);
      expect(hitboxA.collisions.length, 1);
      expect(hitboxB.collisions.length, 1);
      blockB.position = Vector2.all(21);
      expect(hitboxA.endCounter, 0);
      expect(hitboxB.endCounter, 0);
      game.update(0);
      expect(hitboxA.hasCollisionWith(hitboxB), false);
      expect(hitboxB.hasCollisionWith(hitboxA), false);
      expect(hitboxA.collisions.length, 0);
      expect(hitboxB.collisions.length, 0);
      game.update(0);
      expect(hitboxA.endCounter, 1);
      expect(hitboxB.endCounter, 1);
    });
  });
}
