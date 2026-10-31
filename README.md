# godot-agent-bench

A small Godot 4 top-down demo game: a player that moves and fires, enemies that
chase the player and award points when they die, and a HUD that shows the score.
It is used as a fixture by [geekoma9-optimise](https://github.com/YodaTheCoder/geekoma9-optimise);
see that repo for how it is used.

## Layout

| Path | Contents |
| --- | --- |
| `scripts/components/health.gd` | `Health` component: damage, heal, `died` signal |
| `scripts/weapon.gd` | `Weapon`: fire-rate cooldown |
| `scripts/player.gd` | `Player`: movement and firing |
| `scripts/enemy.gd` | `Enemy`: chases its target, awards points on death |
| `scripts/patrol_enemy.gd` | `PatrolEnemy`: patrols waypoints, chases its target when within `aggro_range` |
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
