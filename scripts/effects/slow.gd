class_name Slow extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# This effect is handled in the StatusEffects component
	pass