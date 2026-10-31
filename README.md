# godot-agent-bench

A small Godot 4 top-down game used as the starting point for a coding-agent
benchmark. It is part of [geekoma9-optimise](https://github.com/YodaTheCoder/geekoma9-optimise),
which measures how well local coding agents handle realistic game-dev tasks.

The game is deliberately small: a player that moves and fires, enemies that
chase the player and award points when they die, and a HUD that shows the score.

## Layout

- `main` holds the clean base game (tagged `base-v1`). Agents start from here.
- The `tests` branch holds the benchmark tasks and their hidden tests.
- `exp/*` branches hold the evidence from individual benchmark attempts.

In the game itself:

| Path | Contents |
| --- | --- |
| `scripts/components/health.gd` | `Health` component: damage, heal, `died` signal |
| `scripts/weapon.gd` | `Weapon`: fire-rate cooldown |
| `scripts/player.gd` | `Player`: movement and firing |
| `scripts/enemy.gd` | `Enemy`: chases its target, awards points on death |
| `scripts/hud.gd` | `HUD`: score label |
| `scripts/score_manager.gd` | `ScoreManager` autoload: the running score |
| `scenes/` | Player, enemy, HUD and main scenes |
| `tests/regression/` | GUT regression tests |
| `addons/gut/` | Vendored [GUT](https://github.com/bitwes/Gut) 9.7.1 (MIT) |

## Running the regression tests

You need Godot 4.7.2 (see `.godot-version`). From the repo root:

```sh
godot --headless --path . --import
godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests/regression -gexit
```

The first command builds the import cache that GUT needs to resolve `class_name`
scripts on a fresh checkout. The second exits with status 0 when every test passes.

## License

MIT, see `LICENSE`. GUT keeps its own MIT license in `addons/gut/LICENSE.md`.
