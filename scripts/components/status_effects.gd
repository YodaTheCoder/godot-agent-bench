class_name StatusEffects
extends Node

# Store active effects with their specific tracking needed for various effects
var active_effects: Array[Dictionary] = []

func _physics_process(delta: float) -> void:
	tick(delta)

func add(effect: StatusEffect) -> void:
	# Add a new effect entry for tracking - we may need to track specific information per effect type
	var entry = {
		"effect": effect,
		"remaining_time": effect.duration,
	}
	
	# Add extra tracking data based on effect type
	if effect is Poison:
		entry["damage_owed"] = 0.0
	
	active_effects.append(entry)

func tick(delta: float) -> void:
	var i = 0
	while i < active_effects.size():
		var entry = active_effects[i]
		var effect = entry["effect"]
		var remaining_time = entry["remaining_time"]
		
		if remaining_time <= 0:
			i += 1
			continue
			
		# Determine how much time we can apply this effect (not more than the effect's duration)
		var step = min(delta, remaining_time)
		
		# Apply effects here based on type - since Poison needs accumulated damage tracking,
		# we handle those operations directly within StatusEffects
		if effect is Poison:
			# This is how we would call actual damage processing:
			var damage_owed = entry["damage_owed"]
			damage_owed += effect.damage_per_second * step
			
			# Calculate integer part for dealing damage
			var damage_to_deal = int(damage_owed)
			
			# Apply to target's Health if it exists
			var parent = get_parent()
			if parent:
				var health_node = parent.get_node("Health") as Health
				if health_node and damage_to_deal > 0:
					health_node.damage(damage_to_deal)
			
			# Store remaining fractional part for next tick
			entry["damage_owed"] = damage_owed - damage_to_deal
		else:
			# Regular apply_tick call for other effects 
			effect.apply_tick(get_parent(), step)
		
		# Update remaining time and check if effect should expire
		remaining_time -= step
		entry["remaining_time"] = remaining_time
		
		# If this effect has completed its duration, remove it 
		if remaining_time >= effect.duration:
			active_effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return active_effects.size()

func speed_multiplier() -> float:
	var multiplier = 1.0
	
	for entry in active_effects:
		if entry["effect"] is Slow:
			multiplier *= entry["effect"].multiplier
	
	return multiplier
