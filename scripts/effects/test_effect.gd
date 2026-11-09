class_name TestPoisonEffect
extends StatusEffect

# Simple test effect for verifying functionality
@export var damage_per_second := 1.0


func apply_tick(target: Node, delta: float) -> void:
	var health_node = target.get_node("Health")
	if not health_node or not health_node.has_method("damage"):
		return
	
	var total_damage = damage_per_second * delta
	var whole_damage = int(total_damage)
	
	if whole_damage > 0:
		health_node.damage(whole_damage)