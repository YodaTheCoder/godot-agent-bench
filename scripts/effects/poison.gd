class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var _damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	_damage_owed += damage_per_second * delta
	
	var health_node = target.get_node("Health") as Health
	if health_node == null:
		return
		
	var damage_dealt = int(_damage_owed)
	_damage_owed -= damage_dealt
	health_node.damage(damage_dealt)