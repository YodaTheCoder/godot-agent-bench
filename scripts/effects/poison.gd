class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

func apply_tick(target: Node, delta: float) -> void:
	# This method should not be directly called by users for poison effects as 
	# damage application is handled internally in StatusEffects.
	# This is just to satisfy the interface requirement of having an implementation
	pass
