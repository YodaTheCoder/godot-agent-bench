# Add a patrolling enemy that chases the player when it gets close

## Context

`Enemy` (`scripts/enemy.gd`, `class_name Enemy extends CharacterBody2D`, scene
`scenes/enemy.tscn`) always walks straight at its `target`:

- `@export var points := 10`, `@export var speed := 80.0`, `@export var target: Node2D`
- `@onready var health: Health = $Health`; `_ready()` connects `health.died` so that the
  enemy awards its points and frees itself when it dies.
- `_physics_process(_delta)` sets `velocity = direction_to_target() * speed` and calls
  `move_and_slide()`.
- `func direction_to_target() -> Vector2`: unit vector towards `target`
  (`Vector2.ZERO` when `target` is null).

`scenes/enemy.tscn` has a `CharacterBody2D` root named `Enemy` with children `Body`
(`Polygon2D`), `CollisionShape2D` and `Health`.

We want a second kind of enemy that walks a patrol route and only goes after the player
when the player comes close.

## Requirements

### 1. Script: new file `scripts/patrol_enemy.gd`

```gdscript
class_name PatrolEnemy
extends Enemy
```

Members:

- `@export var waypoints: PackedVector2Array`: the patrol route, in **global**
  coordinates.
- `@export var aggro_range := 150.0` (a `float`, pixels).
- `func next_waypoint_index() -> int`: the index in `waypoints` of the waypoint the enemy
  is currently heading to. It is `0` for a new enemy (also when `waypoints` is empty).
- `func is_chasing() -> bool`: `true` when `target` is not null and the distance from the
  enemy's `global_position` to `target.global_position` is at most `aggro_range`
  (exactly `aggro_range` counts as inside); otherwise `false`. It always uses the current
  values (positions and `aggro_range` may change at any time).

Keep everything `PatrolEnemy` inherits from `Enemy` working (points, `speed`, `target`,
the `Health` child, scoring and freeing on death).

### 2. Movement: override `_physics_process(delta: float) -> void`

Each call does exactly one of the following, then calls `move_and_slide()`:

1. **Chasing** (`is_chasing()` is true): `velocity = direction_to_target() * speed`.
   While chasing, the patrol index does not change (the enemy resumes the same waypoint
   when it stops chasing).
2. **Patrolling** (not chasing, `waypoints` not empty):
   - if the enemy's `global_position` is within `4.0` pixels of
     `waypoints[next_waypoint_index()]` (distance `<= 4.0`), the waypoint is reached and
     the index advances to the next waypoint; after the last waypoint it wraps around to
     `0`. At most one advance per call.
   - `velocity` is the unit vector from `global_position` towards the (possibly new)
     current waypoint, times `speed`.
3. **Idle** (not chasing, `waypoints` empty): `velocity = Vector2.ZERO`. This must not
   raise an error.

Tests call `_physics_process(...)` directly and set `global_position` between calls, so
the behaviour must depend only on the state at the time of the call (no timers, no
`await`).

### 3. Scene: new file `scenes/patrol_enemy.tscn`

A scene whose root is a `PatrolEnemy` (the root has `scripts/patrol_enemy.gd` attached)
and that has the same children as `scenes/enemy.tscn`, including a `Health` node with
`scripts/components/health.gd`. Making it an inherited scene of `scenes/enemy.tscn` is
the simplest way. Instancing it must not raise errors.

## Acceptance criteria

- `load("res://scenes/patrol_enemy.tscn").instantiate()` is a `PatrolEnemy` (and so an
  `Enemy`), has a `Health` child, `aggro_range == 150.0` and `next_waypoint_index() == 0`.
- With `waypoints = [(0, 0), (100, 0), (100, 100)]`, repeatedly placing the enemy on the
  current waypoint and calling `_physics_process(1.0 / 60.0)` makes
  `next_waypoint_index()` go `0 → 1 → 2 → 0 → 1`.
- Standing at `(3, 0)` with the current waypoint at `(0, 0)` counts as arrived.
- Not yet at the waypoint: the index stays the same and `velocity` points at the waypoint
  with length `speed` (e.g. enemy at `(0, 0)`, waypoint `(300, 0)` →
  `velocity == (speed, 0)`).
- `is_chasing()` is false with no target, true when the target is 100 px away, false when
  it is 200 px away, and true again at 200 px after setting `aggro_range = 250.0`.
- While chasing, `_physics_process` sets `velocity` towards the target with length `speed`
  and does not change `next_waypoint_index()`.
- With no waypoints and no target, `_physics_process` leaves `velocity == Vector2.ZERO`
  and `next_waypoint_index() == 0`.
- The tests in `tests/regression/` still pass.
- The test runner treats any engine error or `push_error` raised while a test runs as a failure.
