class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

func apply_tick(target: Node, delta: float) -> void:
	var health_node = target.get_node("Health")
	if not health_node or not health_node.has_method("damage"):
		return
	
	var total_damage_owed = 0.0
	var damage_to_deal = 0
	
	# Get the existing damage owed from previous ticks
	if target.has_meta("poison_damage_owed"):
		total_damage_owed = target.get_meta("poison_damage_owed")
	
	# Add new damage owed
	total_damage_owed += damage_per_second * delta
	
	# Deal integer part of damage
	damage_to_deal = int(total_damage_owed)
	if damage_to_deal > 0:
		health_node.damage(damage_to_deal)
	
	# Keep fractional remainder for next tick
	target.set_meta("poison_damage_owed", total_damage_owed - damage_to_deal)