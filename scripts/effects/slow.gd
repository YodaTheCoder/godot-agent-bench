class_name Slow extends StatusEffect

@export var multiplier := 0.5


func apply_tick(target: Node, delta: float) -> void:
	# Base class does nothing, this effect is handled by the StatusEffects component
	pass