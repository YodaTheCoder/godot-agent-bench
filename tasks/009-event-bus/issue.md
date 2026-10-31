# Decouple Enemy from ScoreManager with a global `Events` bus

## Context

When an enemy dies it calls the score autoload directly. In `scripts/enemy.gd`
(`class_name Enemy extends CharacterBody2D`, scene `scenes/enemy.tscn`):

```gdscript
func _on_health_died() -> void:
	ScoreManager.add_points(points)
	queue_free()
```

`ScoreManager` is an autoload registered in `project.godot`:

```ini
[autoload]

ScoreManager="*res://scripts/score_manager.gd"
```

`scripts/score_manager.gd` (`extends Node`, no `class_name`) has `var score: int`,
`func add_points(n: int) -> void` and `func reset() -> void`.

We want gameplay objects to announce what happened on a global event bus, and systems
such as scoring to listen to it, so that `Enemy` no longer depends on `ScoreManager`.

## Requirements

### 1. New autoload `Events`

- New file `scripts/events.gd`, `extends Node`, declaring:

  ```gdscript
  signal enemy_died(points: int)
  ```

  Do not give it a `class_name` (an autoload's name and a `class_name` must not clash).
  Godot warns about a signal that is never emitted in its own script; silence that with
  `@warning_ignore("unused_signal")` on the signal.
- Register it in `project.godot` under the name `Events`, **before** `ScoreManager`, so
  that it exists when `ScoreManager` starts. The `[autoload]` section must read:

  ```ini
  [autoload]

  Events="*res://scripts/events.gd"
  ScoreManager="*res://scripts/score_manager.gd"
  ```

### 2. Enemy emits the event

In `scripts/enemy.gd`, when the enemy dies, emit `Events.enemy_died` with the enemy's
`points` (once per death), then `queue_free()` as before. `scripts/enemy.gd` must no
longer refer to `ScoreManager` at all: the text `ScoreManager` must not appear anywhere
in that file, comments included.

### 3. ScoreManager listens

In `scripts/score_manager.gd`, add a `_ready()` that connects `Events.enemy_died` to a
method of `ScoreManager` that adds the received points to the score (via `add_points`).
Connect exactly once, in ScoreManager's own `_ready()` (not from the enemy or any other
node). Keep `score`, `add_points(n: int)` and `reset()` working as before; `reset()` must
not disconnect the listener.

The handling is synchronous: right after `Events.enemy_died` is emitted, `ScoreManager.score`
already includes the points.

## Acceptance criteria

- `/root/Events` exists, has a signal `enemy_died` with one argument, and comes before
  `/root/ScoreManager` among the root's children (autoload order).
- With `ScoreManager.score == 0`, emitting `Events.enemy_died` with `10` makes the score
  `10`; emitting it again with `25` makes it `35` (each emission is counted once).
- One of the connections of `Events.enemy_died` belongs to the `ScoreManager` autoload.
- `scripts/enemy.gd` does not contain the text `ScoreManager`.
- Killing an enemy instanced from `scenes/enemy.tscn` with `points = 25` (damaging its
  `Health` by `max_health`) emits `Events.enemy_died(25)` exactly once, adds 25 to
  `ScoreManager.score`, and queues the enemy for deletion.
- The tests in `tests/regression/` still pass (including the one that kills an enemy and
  checks the score).
- The test runner treats any engine error or `push_error` raised while a test runs as a failure.
