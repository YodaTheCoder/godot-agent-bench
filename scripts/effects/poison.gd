class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	damage_owed += damage_per_second * delta
	
	var health_node = target.get_node("Health") as Node
	if health_node != null and health_node.has_method("damage"):
		var damage_dealt = int(damage_owed)
		damage_owed -= damage_dealt
		health_node.damage(damage_dealt)