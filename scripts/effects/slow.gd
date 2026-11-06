class_name Slow extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# Slow effect doesn't do anything on tick, it just affects the speed multiplier
	pass