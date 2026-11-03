class_name StatusEffect
extends Resource

@export var duration := 1.0

var owed_damage: float = 0.0

func apply_tick(target: Node, delta: float) -> void:
	pass