# Add a wave spawner that releases enemies in timed waves

## Context

Enemies are currently placed by hand in `scenes/main.tscn` (root `Main`, a `Node2D`, with
children `Player`, `Enemy1`, `Enemy2` and `HUD`). The enemy scene is
`scenes/enemy.tscn` (root script `scripts/enemy.gd`, `class_name Enemy`, with
`@export var target: Node2D`). We want a reusable spawner that releases enemies in waves,
configured with resources in the editor.

## Requirements

### 1. `WaveConfig` resource: new file `scripts/wave_config.gd`

```gdscript
class_name WaveConfig
extends Resource

@export var enemy_scene: PackedScene   # default null
@export var count := 1                 # int: number of enemies in the wave
@export var interval := 1.0            # float: seconds between two spawns of this wave
```

### 2. `WaveSpawner` node: new file `scripts/wave_spawner.gd`

```gdscript
class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0   # float, seconds
@export var autostart := false
@export var target: Node2D
```

- `func start() -> void` starts (or restarts) the sequence from wave 0. `start()` itself
  spawns nothing.
- If `autostart` is true, the spawner calls `start()` in `_ready()`.
- Spawning is driven **only** from `func _process(delta: float) -> void`, using the
  `delta` it is given (no `Timer` nodes, no `await`, no reading the clock). The tests
  call `_process(...)` directly with fixed deltas. Before `start()` is called,
  `_process` does nothing.
- Each spawned enemy is `wave.enemy_scene.instantiate()`, added with `add_child` as a
  child of the WaveSpawner itself, at the spawner's origin. If `target` is set and the
  spawned node has a `target` property, set it to `target`.
- Tests may set `waves` (by appending to it), `wave_delay` and the wave fields before
  calling `start()`. You may assume `waves` is not empty and every `count >= 1`.

### 3. Timing rule (exact)

Let `elapsed` be the sum of all `delta` values passed to `_process` since `start()`,
including the current call. Every enemy has a scheduled time:

- wave 0 starts at `S0 = 0.0`;
- enemy `k` (0-based) of wave `i` is scheduled at `Si + k * waves[i].interval`;
- wave `i + 1` starts `wave_delay` seconds after the **scheduled** time of the last enemy
  of wave `i`: `S(i+1) = Si + (waves[i].count - 1) * waves[i].interval + wave_delay`.

During each `_process(delta)` call, after adding `delta` to `elapsed`, spawn every
not-yet-spawned enemy whose scheduled time is `<= elapsed`, in schedule order. So the
first enemy appears on the first `_process` call after `start()`, and one call with a
large `delta` may spawn several enemies, even across several waves.

Signals:

- `wave_finished(i)` is emitted right after the last enemy of wave `i` has been added as
  a child, before any enemy of wave `i + 1` is spawned.
- `all_waves_finished` is emitted right after `wave_finished` of the last wave, in the
  same call.
- After that, `_process` spawns nothing more and emits no more signals (until `start()`
  is called again).

Worked example: wave 0 = 3 enemies, `interval = 0.5`; wave 1 = 2 enemies,
`interval = 0.25`; `wave_delay = 1.0`. Scheduled times: wave 0 at 0.0, 0.5, 1.0; wave 1
at 2.0, 2.25. Calling `_process(0.25)` ten times after `start()` gives, after each call,
1, 2, 2, 3, 3, 3, 3, 4, 5, 5 enemies; `wave_finished(0)` is emitted during the 4th call
and `wave_finished(1)` followed by `all_waves_finished` during the 9th. A single
`_process(10.0)` instead spawns all 5 enemies and emits the three signals in the same
order (`wave_finished(0)` when 3 enemies exist, the other two when 5 exist).

### 4. Add a spawner to `scenes/main.tscn`

Add exactly one `WaveSpawner` node as a child of `Main` with `autostart = true`,
`target` pointing at `Player`, and at least one `WaveConfig` in `waves`, each with
`enemy_scene` set to `scenes/enemy.tscn` and `count >= 1` (sub-resources in the scene
file are fine). Keep the existing nodes.

## Acceptance criteria

- `WaveConfig.new()` is a `Resource` with `enemy_scene == null`, `count == 1`,
  `interval == 1.0`. `WaveSpawner.new()` is a `Node2D` with `wave_delay == 2.0` and an
  empty `waves` array.
- Before `start()`, `_process(5.0)` spawns nothing and emits nothing; `start()` alone
  spawns nothing.
- The worked example above holds exactly: enemy counts per call, the signal order, the
  call in which each signal fires, and the number of children that are `Enemy`
  instances at each emission.
- After `all_waves_finished`, further `_process` calls spawn nothing and emit nothing.
- `scenes/main.tscn` contains exactly one `WaveSpawner`, whose `waves` is not empty and
  whose every wave has an `enemy_scene` and `count > 0`.
- The tests in `tests/regression/` still pass.
- The test runner treats any engine error or `push_error` raised while a test runs as a failure.
