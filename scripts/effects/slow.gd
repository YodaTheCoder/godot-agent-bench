extends "res://scripts/effects/status_effect.gd"

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# This effect doesn't do anything during tick, as it's handled by the StatusEffects component
	pass