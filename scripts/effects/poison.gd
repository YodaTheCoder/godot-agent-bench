class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var _damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	_damage_owed += damage_per_second * delta
	
	var damage_to_deal = int(_damage_owed)
	_damage_owed -= damage_to_deal
	
	if target.has_node("Health"):
		target.get_node("Health").damage(damage_to_deal)