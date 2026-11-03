class_name StatusEffect
extends Resource

@export var duration := 1.0

var _duration := duration
var _remaining_duration := duration

func apply_tick(target: Node, delta: float) -> void:
	pass
