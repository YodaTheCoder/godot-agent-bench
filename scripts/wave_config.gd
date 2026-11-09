class_name WaveConfig
extends Resource

@export var enemy_scene: PackedScene   # default null
@export var count := 1                 # int: number of enemies in the wave
@export var interval := 1.0            # float: seconds between two spawns of this wave
var wave_start_time: float = 0.0       # internal use only