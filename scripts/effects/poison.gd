class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

# Running total of damage owed
var _damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	# Add to the running damage owed
	_damage_owed += damage_per_second * delta
	
	# Get the target's Health component
	var health_component = target.get_node("Health")
	if not health_component:
		return
		
	# Deal the whole number part of damage owed
	var damage_to_deal = int(_damage_owed)
	if damage_to_deal > 0:
		health_component.damage(damage_to_deal)
		_damage_owed -= damage_to_deal