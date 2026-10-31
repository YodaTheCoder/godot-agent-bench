# Add a player Inventory and collectible item pickups

## Context

The player (`scripts/player.gd`, `class_name Player extends CharacterBody2D`, scene
`scenes/player.tscn`) has no way to collect items. We want a simple item-count inventory
on the player and a reusable pickup scene that can be dropped into levels.

## Requirements

### 1. `Inventory` resource: new file `scripts/inventory.gd`

```gdscript
class_name Inventory
extends Resource
```

It stores a count per item id and has:

- `func add(item_id: StringName, qty: int = 1) -> void`: adds `qty` to the count for
  `item_id` (an item seen for the first time starts from 0).
- `func count(item_id: StringName) -> int`: the current count for `item_id`; `0` for an
  item that was never added.
- Change notification: every `add(...)` call emits the inventory's `changed` signal
  exactly once. Use the `changed` signal that `Resource` already provides (emit it with
  `emit_changed()`); do not declare a new signal called `changed`, since GDScript does not
  allow redeclaring an inherited signal.

Items are independent: adding `&"coin"` does not change `count(&"gem")`.

### 2. `Player.inventory`

In `scripts/player.gd`, add a member `inventory` of type `Inventory`:

```gdscript
var inventory: Inventory = Inventory.new()
```

Every player (e.g. one instanced from `scenes/player.tscn`) must start with its own
non-null, empty inventory.

### 3. Pickup scene: new files `scenes/pickup.tscn` and `scripts/pickup.gd`

- The root node of `scenes/pickup.tscn` is an `Area2D` with the script
  `scripts/pickup.gd` attached (`extends Area2D`). Give it a `CollisionShape2D` child
  (any small shape) so that it can actually detect bodies in game, and optionally a
  visual (e.g. a `Polygon2D`).
- The script has:
  - `@export var item_id: StringName`
  - `@export var qty := 1` (an `int`)
  - `func _on_body_entered(body: Node2D) -> void`
- The root's `body_entered` signal must be connected to `_on_body_entered` (either in the
  scene file or in `_ready()`), so a body entering the area triggers it.
- `_on_body_entered(body)`:
  - if `body` is a `Player`: call `body.inventory.add(item_id, qty)`, then `queue_free()`
    the pickup;
  - for any other body: do nothing (the pickup stays, nothing is added).

## Acceptance criteria

- `Inventory.new().count(&"coin") == 0`.
- `add(&"coin")` then `add(&"coin", 4)` → `count(&"coin") == 5`, and `count(&"gem")`
  is still 0.
- Each `add` emits `changed` once (two `add` calls → two emissions).
- A player instanced from `scenes/player.tscn` has an `inventory` that is an `Inventory`
  with `count(...) == 0` for any item.
- Instance `scenes/pickup.tscn`, set `item_id = &"gem"` and `qty = 3`, add it to the
  scene tree, then call its `_on_body_entered(player)` with a player instanced from
  `scenes/player.tscn`: the player's `inventory.count(&"gem") == 3` and the pickup
  `is_queued_for_deletion()`.
- Emitting the pickup's `body_entered` signal with a player as the argument has the same
  effect.
- `_on_body_entered` with a body that is not a `Player` (e.g. a `StaticBody2D`) leaves
  the pickup in place (not queued for deletion).
- The tests in `tests/regression/` still pass.
