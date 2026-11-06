class_name Slow extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# This is intentionally left empty as the actual slow logic will be handled by the StatusEffects component
	pass