# ScoreManager: combo multiplier for quick successive scores

## Context

`ScoreManager` is an autoload (`project.godot`: `ScoreManager="*res://scripts/score_manager.gd"`,
the script has no `class_name`). Today it has:

- `var score: int`
- `func add_points(n: int) -> void`: `score += n`
- `func reset() -> void`: `score = 0`

`Enemy` calls `ScoreManager.add_points(points)` when it dies. We want to reward kills
that come in quick succession with a growing multiplier.

To keep this deterministic and testable, the caller passes the current time in seconds
instead of `ScoreManager` reading a clock.

## Requirements

All changes are in `scripts/score_manager.gd` (keep it an autoload named `ScoreManager`,
keep `var score: int`).

1. Add `var combo: int`, the current multiplier. It is `1` initially.
2. Change the signature to:

   ```gdscript
   func add_points(n: int, now: float = -1.0) -> void
   ```

   `now` is the current time in seconds (any monotonic clock; the caller decides).
3. **Timed call** (`now >= 0.0`):
   - If there was a previous timed call and `now - <time of the previous timed call> <= 2.0`,
     increase `combo` by 1. Otherwise (first timed call, or more than 2.0 s since the
     previous timed call) set `combo` to 1.
   - Then add `n * combo` to `score`, and remember `now` as the time of the previous
     timed call.
   - The 2.0 s window is measured from the previous call, not from the start of the
     combo, so a chain of calls each less than 2.0 s apart keeps growing.
4. **Untimed call** (`now` omitted, or any negative value): add `n` to `score` with no
   multiplier, and leave `combo` and the remembered time unchanged. This keeps existing
   callers such as `Enemy` (`ScoreManager.add_points(points)`) and the tests in
   `tests/regression/` working exactly as before. You do not need to change `Enemy`.
5. `reset()` sets `score` to 0, sets `combo` back to 1, and forgets the previous call
   time, so the next timed call starts a fresh combo.

## Example

```
add_points(10, 0.0)   # combo 1 -> score 10
add_points(10, 0.5)   # combo 2 -> score 30
add_points(10, 1.0)   # combo 3 -> score 60
add_points(10, 4.0)   # 3.0 s gap: combo back to 1 -> score 70
```

## Acceptance criteria

- Three calls `add_points(10, t)` at t = 0.0, 0.5, 1.0 (after `reset()`) give
  `score == 60` and `combo == 3`.
- Calls at t = 0.0 and 1.0, then t = 3.5 (gap > 2 s): `score == 40` and `combo == 1`.
- Calls at t = 0.0, 1.5, 3.0, 4.5 (each 1.5 s apart): `score == 100` (10 + 20 + 30 + 40).
- `reset()` after a combo, then `add_points(10, 1.0)`: `score == 10`, `combo == 1`.
- `ScoreManager.add_points(10)` followed by `ScoreManager.add_points(5)` still gives 15,
  and the tests in `tests/regression/` still pass.
- The test runner treats any engine error or `push_error` raised while a test runs as a failure.
