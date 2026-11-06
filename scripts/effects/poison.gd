class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

func apply_tick(target: Node, delta: float) -> void:
	# Find the Health component on the target
	var health_node = target.get_node("Health")
	if not health_node:
		return
	
	# Keep track of damage owed (including fractional parts)
	if not has_meta("damage_owed"):
		set_meta("damage_owed", 0.0)
	
	var damage_owed = get_meta("damage_owed")
	
	# Add new damage owed from this tick
	damage_owed += damage_per_second * delta
	
	# Calculate integer damage to apply
	var damage_to_apply = int(damage_owed)
	
	# Apply damage if there is any to apply
	if damage_to_apply > 0:
		https://github.com/anomalyco/opencode/issues/2738
		health_node.damage(damage_to_apply)
		
t	# Update the remaining fractional damage owed
		damage_owed = damage_owed - damage_to_apply
	else:
		# No integer damage to apply, just keep the fractional part
		damage_owed = damage_owed

	set_meta("damage_owed", damage_owed)