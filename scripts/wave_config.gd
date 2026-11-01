class_name WaveConfig
extends Resource

## Scene instanced for each enemy of the wave.
@export var enemy_scene: PackedScene
## Number of enemies in the wave.
@export var count := 1
## Seconds between two spawns of this wave.
@export var interval := 1.0
