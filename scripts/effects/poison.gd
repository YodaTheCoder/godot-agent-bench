class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var _pending_damage := 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health := target.get_node_or_null("Health") as Health
	if not health:
		return
	_pending_damage += damage_per_second * delta
	var to_deal := int(_pending_damage)
	if to_deal > 0:
		health.damage(to_deal)
		_pending_damage -= to_deal