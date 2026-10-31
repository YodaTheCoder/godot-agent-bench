class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

# For the cumulative damage tracking we need to store this as part of the instance
var damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	if not target.has_node("Health"):
		return
	
	var health = target.get_node("Health")
	
	# Calculate damage owed and add to running total
	damage_owed += damage_per_second * delta
	
	# Apply whole number damage
	var damage_dealt = int(damage_owed)
	
	# Apply damage if there's any to deal
	if damage_dealt > 0:
		health.damage(damage_dealt)
	
	# Store the fractional part for next tick
	damage_owed -= damage_dealt