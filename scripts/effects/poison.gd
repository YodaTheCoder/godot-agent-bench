extends "res://scripts/effects/status_effect.gd"

@export var damage_per_second := 5.0

var _damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	# Calculate how much damage is owed over this tick
	var damage_owed := damage_per_second * delta
	
	# Add to the running total of owed damage
	_damage_owed += damage_owed
	
	# Get the target's health node if it exists
	var health_node := target.get_node("Health") as Health
	if health_node == null:
		return
	
	# Deal integer portion of damage owed
	var damage_to_deal := int(_damage_owed)
	if damage_to_deal > 0:
		health_node.damage(damage_to_deal)
	
	# Keep fractional remainder for next tick
	_damage_owed -= damage_to_deal