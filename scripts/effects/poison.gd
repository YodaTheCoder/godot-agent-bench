class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var damage_owed: float = 0.0

func apply_tick(target: Node, delta: float) -> void:
	var child: Health = target.get_node("Health")
	if child == null:
		return
	damage_owed += damage_per_second * delta
	var whole_damage: int = int(damage_owed)
	if whole_damage > 0:
		damage_owed -= whole_damage
		child.damage(whole_damage)