class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var damage_owed: float = 0.0

func apply_tick(target: Node, delta: float) -> void:
	if not target.has_node("Health"):
		return
	
	damage_owed += damage_per_second * delta
	
	var damage_dealt: int = floor(damage_owed)
	if damage_dealt > 0:
		var health_node: Health = target.get_node("Health")
		health_node.damage(damage_dealt)
		damage_owed -= damage_dealt