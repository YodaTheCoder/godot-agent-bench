@tool
extends StatusEffect
class_name Slow

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# This effect doesn't do anything during tick, as it's handled in the StatusEffects component
	pass