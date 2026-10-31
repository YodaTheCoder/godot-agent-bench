# Add a `damaged` signal to Health

## Context

`Health` (`scripts/components/health.gd`, `class_name Health extends Node`) is the
health component used by the player and enemies. It has `@export var max_health := 100`,
`var current: int`, `signal died`, and `func damage(amount: int) -> void`, which lowers
`current` (never below 0), emits `died` once when `current` reaches 0, and ignores any
damage once `current` is 0.

Other code (HUD, hit flashes, sounds) needs to react to every hit, not only to death, but
`Health` gives no notification until the entity dies.

## Requirements

1. Declare a new signal on `Health`, with exactly this name and these parameters:

   ```gdscript
   signal damaged(amount: int, remaining: int)
   ```

2. `damage(amount)` emits `damaged` once per call that actually lowers `current`:
   - `amount` (the first argument) is the health actually lost on this hit, i.e. the old
     `current` minus the new `current`. Normally that equals the `amount` passed in; when
     the hit is bigger than the remaining health it is the remaining health
     (e.g. at 30/100, `damage(50)` emits `damaged(30, 0)`).
   - `remaining` (the second argument) is `current` after the hit.
3. `damaged` is **not** emitted when nothing is lost:
   - `damage(0)`;
   - any `damage(...)` call while `current` is already 0 (dead).
4. On a lethal hit, emit `damaged` first and then `died`. `died` keeps its current
   behaviour (emitted once, when `current` reaches 0).
5. Keep the class name, file path, `died`, and the signatures of `damage` and `heal`
   unchanged. `heal` must not emit `damaged`.

## Acceptance criteria

- At 100/100, `damage(30)` emits `damaged(30, 70)` exactly once.
- At 100/100, `damage(30)` then `damage(20)` emits `damaged` twice, the second time with
  `(20, 50)`.
- `damage(0)` does not emit `damaged`.
- At 100/100, `damage(150)` emits `damaged(100, 0)`, then `died`.
- After death, a further `damage(10)` does not emit `damaged`.
- The tests in `tests/regression/` still pass.
- The test runner treats any engine error or `push_error` raised while a test runs as a failure.
