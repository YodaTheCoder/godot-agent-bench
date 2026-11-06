class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var _damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	if not target.has_node("Health"):
		return
		
	var health = target.get_node("Health")
	
	_damage_owed += damage_per_second * delta
	var damage_to_deal = int(_damage_owed)
	_damage_owed -= damage_to_deal
	
	health.damage(damage_to_deal)