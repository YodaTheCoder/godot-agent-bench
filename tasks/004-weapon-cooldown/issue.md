# Weapon fire_rate is treated as seconds between shots instead of shots per second

## Context

`Weapon` (`scripts/weapon.gd`, `class_name Weapon extends Node`) has:

- `@export var fire_rate := 4.0`, documented as "Shots per second."
- `func try_fire(now: float) -> bool`: called with the current time in seconds; returns
  `true` and records the shot if the weapon may fire, otherwise returns `false`.

The cooldown check is `if now - _last_shot_time < fire_rate: return false`, i.e. it uses
`fire_rate` as a number of seconds. With the default 4.0 the weapon fires once every
4 seconds instead of 4 times per second.

## Requirements

Fix `try_fire(now: float) -> bool` in `scripts/weapon.gd` so that `fire_rate` means
shots per second:

1. The minimum time between two successful shots is `1.0 / fire_rate` seconds.
2. A shot is allowed when at least `1.0 / fire_rate` seconds have passed since the last
   **successful** shot (exactly `1.0 / fire_rate` seconds is allowed). The first shot
   ever is always allowed.
3. A blocked attempt (one that returns `false`) does not count as a shot and does not
   restart the cooldown.
4. The cooldown follows the current value of `fire_rate`, which may be changed from the
   default (e.g. `fire_rate = 2.0` means one shot every 0.5 s).

Keep the class name, file path, `fire_rate` and the `try_fire(now: float) -> bool`
signature unchanged. Time comes only from the `now` argument.

## Acceptance criteria

With the default `fire_rate = 4.0` on a new `Weapon`:

- `try_fire(0.0)` → `true`
- then `try_fire(0.2)` → `false`
- then `try_fire(0.25)` → `true`

With `fire_rate = 2.0`: `try_fire(0.0)` → `true`, `try_fire(0.4)` → `false`,
`try_fire(0.5)` → `true`.

With `fire_rate = 0.5` (one shot every 2 s): `try_fire(0.0)` → `true`,
`try_fire(1.5)` → `false`, `try_fire(2.0)` → `true`.

The tests in `tests/regression/` still pass.

The test runner treats any engine error or `push_error` raised while a test runs as a failure.
