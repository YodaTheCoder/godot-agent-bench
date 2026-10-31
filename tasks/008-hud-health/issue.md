# Show the player's health on the HUD, driven by signals instead of polling

## Context

The HUD (`scripts/hud.gd`, `class_name HUD extends CanvasLayer`, scene `scenes/hud.tscn`)
has one `Label` child, `ScoreLabel`, referenced as `@onready var score_label: Label`.
It refreshes that label in `_process` every frame by reading `ScoreManager.score`.

Relevant existing code:

- `ScoreManager` is an autoload (`scripts/score_manager.gd`, no `class_name`) with
  `var score: int`, `func add_points(n: int) -> void` and `func reset() -> void`.
- `Health` (`scripts/components/health.gd`, `class_name Health extends Node`) has
  `signal died`, `@export var max_health := 100`, `var current: int`,
  `func damage(amount: int) -> void` and `func heal(amount: int) -> void`. `_ready()` sets
  `current = max_health`.

We want the HUD to show the player's health as well, and we want the HUD to stop polling
every frame: both labels must update only when the value they show changes.

## Requirements

### 1. `Health.health_changed`

Add to `scripts/components/health.gd`:

```gdscript
signal health_changed(current: int, max_health: int)
```

Emit it once after every `damage(...)` or `heal(...)` call that changes `current`, with
the new `current` and the node's `max_health`. Calls that do not change `current`
(e.g. `damage` on a dead entity) do not emit it. Keep the existing behaviour of `damage`,
`heal` and `died` as it is.

### 2. `ScoreManager.score_changed`

Add `signal score_changed(score: int)` to `scripts/score_manager.gd`, emitted with the new
score after every `add_points(...)` and every `reset()`.

### 3. HUD

- Add a `Label` child named `HealthLabel` to the HUD root in `scenes/hud.tscn` (place it
  below `ScoreLabel`), and in `scripts/hud.gd`:
  `@onready var health_label: Label = $HealthLabel`.
- Add `func bind_health(h: Health) -> void`. It sets `health_label.text` right away to
  `"HP: <current>/<max_health>"` (for example `"HP: 70/100"`, integers, no spaces around
  the `/`) and connects to `h.health_changed` so that the label is updated with the same
  format every time the health changes.
- The score label keeps its `"Score: <score>"` format (e.g. `"Score: 10"`). The HUD sets
  it in `_ready()` from `ScoreManager.score` and then updates it from
  `ScoreManager.score_changed`.
- `scripts/hud.gd` must **not** define `_process` or `_physics_process` at all (neither
  for the health label nor for the score label). Remove the existing `_process`.

Updates must happen synchronously inside the signal emission: the tests change the
health or score and then read the label text immediately, without waiting for a frame.

Wiring the player's `Health` into the HUD in `scenes/main.tscn` is out of scope.

## Acceptance criteria

- An instance of `scenes/hud.tscn` added to the scene tree has `health_label`, a `Label`
  that is its `HealthLabel` child.
- `bind_health(h)` with a `Health` whose `max_health = 40` (added to the tree, so
  `current == 40`) → `health_label.text == "HP: 40/40"`.
- After `bind_health(h)` with `max_health = 100`: `h.damage(30)` → `"HP: 70/100"`, then
  `h.heal(10)` → `"HP: 80/100"`, then `h.damage(500)` → `"HP: 0/100"`.
- `damage(30)` on a full 100-HP `Health` emits `health_changed(70, 100)`; a following
  `heal(5)` emits `health_changed(75, 100)` (two emissions in total).
- With `ScoreManager.score == 0`, a new HUD shows `"Score: 0"`; `ScoreManager.add_points(10)`
  → `"Score: 10"`; `ScoreManager.reset()` → `"Score: 0"`.
- `hud.gd` defines neither `_process` nor `_physics_process` (checked through the
  script's method list).
- The tests in `tests/regression/` still pass.
- The test runner treats any engine error or `push_error` raised while a test runs as a failure.
