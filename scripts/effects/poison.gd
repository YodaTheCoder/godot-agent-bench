class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

func apply_tick(target: Node, delta: float) -> void:
	var health_node = target.get_node("Health") if target.has_node("Health") else null
	if health_node == null:
		return
	
	# Keep track of accumulated damage
	if not target.has_meta("poison_damage_accumulated"):
		target.set_meta("poison_damage_accumulated", 0.0)
	
	var accumulated = target.get_meta("poison_damage_accumulated")
	accumulated += damage_per_second * delta
	var damage_to_deal = int(accumulated)
	accumulated -= damage_to_deal
	
	if damage_to_deal > 0:
		health_node.damage(damage_to_deal)
	
	target.set_meta("poison_damage_accumulated", accumulated)