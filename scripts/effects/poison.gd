class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var _damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	if not target.has_node("Health"):
		return
	
	var health_node = target.get_node("Health")
	
	# Calculate how much damage is owed
	_damage_owed += damage_per_second * delta
	
	# Deal integer damage
	var damage_dealt := int(_damage_owed)
	if damage_dealt > 0:
		health_node.damage(damage_dealt)
	
	# Keep the fractional remainder for next tick
	_damage_owed -= damage_dealt