class_name StatusEffects
extends Node

# This component manages timed status effects on its parent node.
# It should be added as a child of nodes that have Health components.

var active_effects := []

func _physics_process(delta: float) -> void:
	tick(delta)

func add(effect: StatusEffect) -> void:
	# Create an entry for this effect - we'll track all necessary state here
	var effect_entry = {
		"effect": effect,
		"remaining_time": effect.duration,
		# For poison effects, we track the accumulated damage debt
		"poison_debt": 0.0
	}
	
	active_effects.append(effect_entry)

func tick(delta: float) -> void:
	var i = 0
	
	# Process all active effects
	while i < active_effects.size():
		var effect_entry = active_effects[i]
		var effect = effect_entry["effect"]
		var remaining_time = effect_entry["remaining_time"]
		
		# Calculate how much time this effect should actually tick
		var step = min(delta, remaining_time)
		
		# Apply the effect based on its type
		if effect is Poison:
			apply_poison_effect(effect_entry, effect, step)
		elif effect is Slow:
			apply_slow_effect(effect_entry, effect, step)
		else:
			# Base StatusEffect - just call apply_tick as in base class
			effect.apply_tick(get_parent(), step)
		
		# Update the remaining time
		remaining_time -= step
		effect_entry["remaining_time"] = remaining_time
		
		# Check if we should remove this effect (duration has been reached or exceeded)
		if remaining_time >= effect.duration:
			# Remove effect entirely
			active_effects.remove_at(i)
			continue
			
		i += 1

func apply_poison_effect(effect_entry: Dictionary, poison: Poison, delta: float) -> void:
	var target = get_parent()
	var health_node = target.get_node("Health") as Health
	
	# Skip if no health node
	if not health_node:
		return
	
	# Calculate total damage owed for this tick
	var damage_to_owe = poison.damage_per_second * delta
	
	# Add to our accumulated debt
	var current_debt = effect_entry["poison_debt"]
	var total_debt = current_debt + damage_to_owe
	
	# Apply only the whole number of damage points
	var damage_to_apply = int(total_debt)
	if damage_to_apply > 0:
		health_node.damage(damage_to_apply)
	
	# Update debt to only keep fractional part
	effect_entry["poison_debt"] = total_debt - damage_to_apply

func apply_slow_effect(effect_entry: Dictionary, slow: Slow, delta: float) -> void:
	# For now, this effect just marks that we should reduce speed
	# Actual speed reduction is done by the calling code through speed_multiplier()
	pass

func active_count() -> int:
	return active_effects.size()

func speed_multiplier() -> float:
	var multiplier = 1.0
	
	for effect_entry in active_effects:
		var effect = effect_entry["effect"]
		if effect is Slow:
			multiplier *= effect.multiplier
	
	return multiplier
