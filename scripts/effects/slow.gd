class_name Slow
extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# This effect does nothing in apply_tick, it's handled by the StatusEffects component
	pass