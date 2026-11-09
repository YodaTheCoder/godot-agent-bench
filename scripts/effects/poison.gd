class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0


func apply_tick(target: Node, delta: float) -> void:
	# This will be handled by the StatusEffects component
	pass