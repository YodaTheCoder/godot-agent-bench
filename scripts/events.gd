extends Node
## Global event bus (autoload `Events`). Gameplay code emits here instead of calling
## other systems directly.

@warning_ignore("unused_signal")
signal enemy_died(points: int)
