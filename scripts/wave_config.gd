class_name WaveConfig
extends Resource

@export var enemy_scene: PackedScene
@export var count: int = 1
@export var interval: float = 0.5

func get_total_time() -> float:
	return (count - 1) * interval if count > 1 else 0.0