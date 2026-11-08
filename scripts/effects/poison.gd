class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var _owed: float = 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health: Health = target.get_node_or_null("Health") as Health
	if health == null:
		return
	_owed += damage_per_second * delta
	var to_deal := int(_owed)
	if to_deal > 0:
		health.damage(to_deal)
		_owed -= to_deal