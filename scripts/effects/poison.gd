class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	# Add damage owed for this tick
	damage_owed += damage_per_second * delta
	
	# Get the target's Health component if it exists
	var health_node = target.get_node("Health") as Health
	if health_node == null:
		return
	
	# Deal the whole number part of damage owed
	var damage_dealt = int(damage_owed)
	damage_owed -= damage_dealt
	health_node.damage(damage_dealt)