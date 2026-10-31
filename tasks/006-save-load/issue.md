# Save and load the game state (score and player health)

## Context

There is no way to persist progress. Relevant existing code:

- `ScoreManager` is an autoload (`project.godot`: `ScoreManager="*res://scripts/score_manager.gd"`)
  with `var score: int`, `func add_points(n: int) -> void` and `func reset() -> void`.
- `Player` (`scripts/player.gd`, `class_name Player extends CharacterBody2D`, scene
  `scenes/player.tscn`) has a child node named `Health` (`class_name Health`,
  `scripts/components/health.gd`) whose `var current: int` is the player's current health.

We want a small save system built on Godot resources (`ResourceSaver` / `ResourceLoader`,
`.tres` files).

## Requirements

### 1. `SaveData` resource: new file `scripts/save_data.gd`

```gdscript
class_name SaveData
extends Resource

@export var score: int = 0
@export var player_health: int = 0
@export var inventory: Dictionary = {}
```

The fields must be `@export`ed so that they are written to and read from the `.tres`
file. `inventory` is reserved for item counts (item id → count). The game has no player
inventory yet, so `save` stores an empty `Dictionary` and `load_into` ignores this field.

### 2. `SaveGame` autoload: new file `scripts/save_game.gd`

- `scripts/save_game.gd` `extends Node` and is registered in `project.godot` as an
  autoload named `SaveGame`:

  ```
  [autoload]
  ScoreManager="*res://scripts/score_manager.gd"
  SaveGame="*res://scripts/save_game.gd"
  ```

  Do not give the script `class_name SaveGame` (that would clash with the autoload name).
- The default save file is `"user://save.tres"`. Both methods take the path as an
  optional last argument with exactly that default. Callers (including tests) may pass
  any other `user://...tres` path, and the methods must then use only that path.
- `func save(player: Player, path: String = "user://save.tres") -> Error`
  - Creates a `SaveData` with `score = ScoreManager.score`,
    `player_health = <the player's Health child>.current` and `inventory = {}`.
  - Writes it with `ResourceSaver.save(data, path)` and returns the resulting `Error`
    (`OK` on success).
- `func load_into(player: Player, path: String = "user://save.tres") -> bool`
  - If there is no file at `path`, or the file does not load as a `SaveData`, return
    `false` and change nothing (`ScoreManager.score` and the player's health stay as
    they were).
  - A missing file is a normal case, not an error: return `false` without printing an
    engine error and without calling `push_error`. Check first with
    `ResourceLoader.exists(path)` or `FileAccess.file_exists(path)` instead of calling
    `ResourceLoader.load` on a path that may not exist (that prints an engine error).
  - Otherwise set `ScoreManager.score = data.score` and the player's `Health` child's
    `current = data.player_health`, and return `true`.
  - It must read the file as it is on disk now: if the same path was saved, loaded and
    saved again, the second load must see the new contents (for example, load with
    `ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)`).

## Acceptance criteria

- With `ScoreManager.score = 120` and the player's health at 35,
  `SaveGame.save(player, "user://some_test_save.tres")` returns `OK`, the file exists,
  and loading it gives a `SaveData` with `score == 120`, `player_health == 35`,
  `inventory == {}`.
- After that save, changing the score and health, then
  `SaveGame.load_into(player, "user://some_test_save.tres")` returns `true` and restores
  score 120 and health 35.
- `SaveGame.load_into(player, "user://does_not_exist.tres")` returns `false` and leaves
  the score and health unchanged.
- `load_into` on a file that holds some other resource type returns `false` and changes
  nothing.
- `SaveGame.save(player)` / `SaveGame.load_into(player)` with no path use
  `user://save.tres`.
- The tests in `tests/regression/` still pass.
- The test runner treats any engine error or `push_error` raised while a test runs as a failure.
