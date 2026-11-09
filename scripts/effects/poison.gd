class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	damage_owed += damage_per_second * delta
	
	var health_node = target.get_node("Health")
	if not health_node or not health_node.has_method("damage"):
		return
	
	var damage_dealt := int(damage_owed)
	damage_owed -= damage_dealt
	if damage_dealt > 0:
		health_node.damage(damage_dealt)