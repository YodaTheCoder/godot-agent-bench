# Health.heal() can overheal past max_health and revive dead entities

## Context

`Health` (`scripts/components/health.gd`, `class_name Health extends Node`) is the
health component used by the player and enemies. It has:

- `@export var max_health := 100`
- `var current: int` (set to `max_health` in `_ready`)
- `func damage(amount: int) -> void`: lowers `current`, never below 0, emits `died` once
  when `current` reaches 0, and ignores further damage once `current` is 0.
- `func heal(amount: int) -> void`: currently just does `current += amount`.

Two bugs in `heal`:

1. Healing is not capped: a `Health` at 90/100 healed by 50 ends up at 140.
2. Healing works on a dead entity: a `Health` at 0 healed by 20 goes back to 20, even
   though it has already emitted `died` and ignores damage.

## Requirements

Change `Health.heal(amount: int) -> void` in `scripts/components/health.gd` so that:

1. After healing, `current` is never greater than `max_health`. Healing that would go past
   the maximum sets `current` to exactly `max_health`. This uses the instance's own
   `max_health`, which may be set to something other than 100.
2. If `current` is 0 (the entity is dead), `heal` does nothing: `current` stays 0.
3. Healing below the maximum still works as before (e.g. 50/100 healed by 20 gives 70).

Keep the class name, file path, and the signatures of `damage`, `heal` and the `died`
signal unchanged.

## Acceptance criteria

- `max_health = 100`, `damage(10)`, then `heal(50)` → `current == 100`.
- At full health, `heal(25)` → `current == 100`.
- `max_health = 40`, `damage(10)`, then `heal(100)` → `current == 40`.
- `damage(100)` (dead), then `heal(20)` → `current == 0`.
- Existing behaviour and the tests in `tests/regression/` still pass.
