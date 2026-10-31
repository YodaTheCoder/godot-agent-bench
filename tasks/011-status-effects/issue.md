# Add timed status effects (poison and slow) with a StatusEffects component

## Context

Relevant existing code:

- `Health` (`scripts/components/health.gd`, `class_name Health extends Node`):
  `@export var max_health := 100`, `var current: int`, `func damage(amount: int) -> void`
  (integer damage only). `_ready()` sets `current = max_health`.
- `Player` (`scripts/player.gd`, `class_name Player extends CharacterBody2D`, scene
  `scenes/player.tscn` with children `Body`, `CollisionShape2D`, `Health`, `Weapon`):
  `@export var speed := 200.0`, `static func compute_velocity(input: Vector2, speed: float) -> Vector2`,
  and `_physics_process` which sets `velocity = compute_velocity(input, speed)`.
- `scenes/enemy.tscn` (`class_name Enemy`) also has a `Health` child.

We want timed status effects that can be put on any node that has a `Health` child:
poison (damage over time) and slow (reduced movement speed).

## Requirements

### 1. Effect resources

New files (all `extends` as shown, with these `class_name`s):

- `scripts/effects/status_effect.gd`:
  `class_name StatusEffect extends Resource`, with `@export var duration := 1.0`
  (seconds, `float`) and `func apply_tick(target: Node, delta: float) -> void`, which
  does nothing in the base class.
- `scripts/effects/poison.gd`: `class_name Poison extends StatusEffect`, with
  `@export var damage_per_second := 5.0` (`float`).
- `scripts/effects/slow.gd`: `class_name Slow extends StatusEffect`, with
  `@export var multiplier := 0.5` (`float`); its `apply_tick` does nothing.

**Poison damage (exact rule).** `Health` only takes integer damage, so each `Poison`
keeps a running total of damage owed: every `apply_tick(target, delta)` adds
`damage_per_second * delta` to it, then deals the whole-number part of what is owed
and not yet dealt with `damage(...)` on the target's child node named `Health`, and
carries the fractional remainder over to the next call. Example: 5 damage per second
ticked in steps of 0.5 s owes 2.5, 5.0, 7.5, 10.0 in total, so it deals 2, 3, 2, 3
(health 100 → 98 → 95 → 93 → 90). Calling `apply_tick(player, 1.0)` once on a new
`Poison` with 5 damage per second deals 5. If the target has no `Health` child, poison
does nothing (no error).

Each effect instance is added to one component once; tests always create a new
instance for every `add`.

### 2. `StatusEffects` component: new file `scripts/components/status_effects.gd`

`class_name StatusEffects extends Node`. It acts on its **parent node** (the "target").

- `func add(effect: StatusEffect) -> void`: activates `effect` for `effect.duration`
  seconds. Effects stack: adding two poisons deals both; adding two slows multiplies.
- `func tick(delta: float) -> void`: advances every active effect by `delta` seconds:
  - the effect is applied for `step = min(delta, its remaining time)` by calling
    `effect.apply_tick(get_parent(), step)`, so an effect never acts for more than its
    `duration` in total (a poison of 5 per second for 2 s deals exactly 10, even with a
    single `tick(3.0)`);
  - an effect whose total ticked time has reached its `duration` (`>= duration`; exactly
    `duration` counts) is removed at the end of that `tick` call and has no further
    effect.
- `func active_count() -> int`: number of active effects.
- `func speed_multiplier() -> float`: product of the `multiplier`s of all active `Slow`
  effects; `1.0` when there are none.
- The component calls `tick(delta)` from its own `_physics_process(delta)` so effects run
  in game. Nothing else may call `tick` during normal play. Tests do not wait for frames:
  they call `tick(...)` directly with fixed values, and all behaviour must follow from
  those calls (no timers, no reading the clock).

### 3. Player integration

- Add a child `Node` named `StatusEffects` with `scripts/components/status_effects.gd`
  to `scenes/player.tscn`, and in `scripts/player.gd`:
  `@onready var status_effects: StatusEffects = $StatusEffects`.
- Add `func effective_speed() -> float` returning `speed * status_effects.speed_multiplier()`.
- `_physics_process` uses `compute_velocity(input, effective_speed())` instead of
  `compute_velocity(input, speed)`. Keep `compute_velocity` as it is.

## Acceptance criteria

All with a player instanced from `scenes/player.tscn` and added to the scene tree (health
100, `speed` 200) unless stated otherwise:

- `Poison` and `Slow` are `StatusEffect`s (and `Resource`s); defaults: `duration == 1.0`,
  `damage_per_second == 5.0`, `multiplier == 0.5`. The player has a `StatusEffects` child
  named `StatusEffects`, which is `player.status_effects`; it starts with
  `active_count() == 0`, and `effective_speed() == 200.0`.
- Poison 5/s for 2 s, then `tick(0.5)` four times → health 98, 95, 93, 90 and
  `active_count() == 0`; two more `tick(0.5)` → still 90.
- Same poison, one `tick(3.0)` → health 90, `active_count() == 0`.
- `Poison.apply_tick(player, 1.0)` on a new 5/s poison → health 95.
- Two poisons of 5/s for 2 s: `tick(1.0)` → 90, `tick(1.0)` → 80, `tick(1.0)` → 80.
- Slow 0.5 for 1 s: `speed_multiplier() == 0.5`, `effective_speed() == 100.0`; after
  `tick(0.5)` still 100.0; after another `tick(0.5)` → 200.0 and `speed_multiplier() == 1.0`.
- With `speed = 300.0`, slows 0.5 for 1 s and 0.5 for 2 s → `effective_speed() == 75.0`;
  after `tick(1.0)` → 150.0.
- A `StatusEffects` added as a child of an enemy from `scenes/enemy.tscn`: poison 4/s for
  1 s, `tick(1.0)` → the enemy's `Health.current == 96`.
- The tests in `tests/regression/` still pass.
- The test runner treats any engine error or `push_error` raised while a test runs as a failure.
