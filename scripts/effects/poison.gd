extends StatusEffect

@export var damage_per_second := 5.0

# Track damage that has been owed but not yet dealt with
var damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	if not target.has_node("Health"):
		return
		
	var health = target.get_node("Health")
	
	# Add to the running damage owed
	damage_owed += damage_per_second * delta
	
	# Deal the whole number part of the damage owed
	var damage_to_deal = int(damage_owed)
	if damage_to_deal > 0:
		health.damage(damage_to_deal)
		damage_owed -= damage_to_deal