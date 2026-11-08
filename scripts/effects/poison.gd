extends StatusEffect

class_name Poison

@export var damage_per_second := 5.0

var damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	if not target.has_node("Health"):
		return
	
	damage_owed += damage_per_second * delta
	var damage_dealt := int(damage_owed)
	damage_owed -= damage_dealt
	target.get_node("Health").damage(damage_dealt)