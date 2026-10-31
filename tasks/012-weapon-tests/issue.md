# Weapon: fix the cooldown, add `reset()`, and write tests that would have caught the bug

## Context

`Weapon` (`scripts/weapon.gd`, `class_name Weapon extends Node`) has:

- `@export var fire_rate := 4.0`, documented as "Shots per second."
- `func try_fire(now: float) -> bool`: called with the current time in seconds; returns
  `true` and records the shot if the weapon may fire, otherwise returns `false`.

Its cooldown check is `if now - _last_shot_time < fire_rate: return false`, so it treats
`fire_rate` as seconds between shots: with the default 4.0 it fires once every 4 seconds
instead of 4 times per second. The only tests (`tests/regression/test_weapon.gd`) check
that the first shot fires and that a second shot at the same time is blocked, which is
why the bug slipped through. We also need a way to clear the cooldown, e.g. when a level
restarts.

## Requirements

### 1. Intended `Weapon` behaviour (fix `scripts/weapon.gd` to match)

1. `fire_rate` is shots per second. The minimum time between two successful shots is
   `1.0 / fire_rate` seconds.
2. A shot is allowed when at least `1.0 / fire_rate` seconds have passed since the last
   **successful** shot; exactly `1.0 / fire_rate` seconds is allowed. The first shot
   ever is always allowed.
3. A blocked attempt (one that returns `false`) does not count as a shot and does not
   restart the cooldown.
4. The cooldown follows the current value of `fire_rate`, which may be changed from the
   default (e.g. `fire_rate = 2.0` means one shot every 0.5 s).
5. New: `func reset() -> void` clears the cooldown, so the next `try_fire(now)` succeeds
   for any `now` (even a time earlier than the last shot, since a restarted level may
   restart its clock). After that shot the cooldown works normally again. `reset()` does
   not change `fire_rate`, and calling it on a weapon that has never fired is harmless.

Keep the class name, file path, `fire_rate` and the `try_fire(now: float) -> bool`
signature unchanged. Time comes only from the `now` argument.

### 2. Tests: new file `tests/test_weapon_extra.gd`

Write a GUT test script (`extends GutTest`, test methods named `test_...`) at exactly
`tests/test_weapon_extra.gd` that checks the behaviour in section 1.

How it will be graded: your test file is copied into fresh copies of your project in
which `scripts/weapon.gd` is replaced by our reference implementation of section 1, and
run on its own with GUT.

- It must **pass** (at least one test, no failing test) on the reference implementation.
- It must **fail** (at least one failing test) on each of several deliberately broken
  versions of the reference. There are three, one for each of these bugs:
  - an off-by-one at the cooldown boundary: a shot exactly `1.0 / fire_rate` seconds
    after the last one is blocked;
  - `reset()` that does not clear the cooldown;
  - `fire_rate` used as seconds between shots instead of shots per second (the current
    bug).

Rules for the test file:

- Use only the public API: `Weapon.new()`, `fire_rate`, `try_fire(now)` and `reset()`.
  Do not read or write private members such as `_last_shot_time`: the reference may
  store its state differently.
- Do not depend on other project files or on your own changes elsewhere, apart from
  `scripts/weapon.gd`.
- No `await`, timers or real time: pass explicit times to `try_fire`. Prefer times that
  are exact in binary floating point (e.g. 0.25, 0.5, 1.25) so that boundary checks are
  not affected by rounding.
- Free what you create (e.g. `add_child_autofree(Weapon.new())`).

`.gutconfig.json` only lists `tests/regression`, so run your file explicitly, e.g.
`godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/test_weapon_extra.gd -gexit`
(this also runs the regression tests).

## Acceptance criteria

- With the default `fire_rate = 4.0`: `try_fire(0.0)` → `true`, then `try_fire(0.2)` →
  `false`, then `try_fire(0.25)` → `true`.
- `try_fire(0.0)` → `true`, `reset()`, `try_fire(0.0)` → `true`.
- `reset()` on a new weapon, then `try_fire(0.0)` → `true` and `try_fire(0.125)` → `false`.
- `try_fire(1.0)`, `reset()`, then `try_fire(1.0)` → `true`, `try_fire(1.125)` → `false`,
  `try_fire(1.25)` → `true`.
- `try_fire(10.0)`, `reset()`, then `try_fire(3.0)` → `true`.
- `fire_rate = 2.0`, `reset()` → `fire_rate` is still `2.0`.
- `tests/test_weapon_extra.gd` passes on the reference implementation and fails on each
  broken version described above.
- The tests in `tests/regression/` still pass.
- The test runner treats any engine error or `push_error` raised while a test runs as a failure.
