class_name Slow
extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# Base class does nothing - this is just here for the effect to be valid
	# Actual slow application will be handled by StatusEffects component
	pass
