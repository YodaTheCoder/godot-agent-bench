class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

func apply_tick(target: Node, delta: float) -> void:
	# Poison effect is handled through the StatusEffects component 
	# which tracks accumulated damage debt properly
	pass
