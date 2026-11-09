class_name StatusEffects
extends Node

var active_effects: Array[Dictionary] = []
# Track damage owed for each effect instance
var effect_damage_owed: Dictionary = {}


func add(effect: StatusEffect) -> void:
	var effect_data = {
		"effect": effect,
		"remaining_time": effect.duration
	}
	active_effects.append(effect_data)
	
	# Initialize tracking for this effect (only for Poison effects)
	if effect is Poison:
		effect_damage_owed[ effect ] = 0.0


func tick(delta: float) -> void:
	var i = 0
	while i < active_effects.size():
		var effect_data = active_effects[i]
		var effect = effect_data["effect"]
		var remaining_time = effect_data["remaining_time"]
		
		# Determine how much time to apply this tick
		var step = min(delta, remaining_time)
		
		# Apply the effect based on its type
		if effect is Poison:
			apply_poison_tick(effect, get_parent(), step)
		elif effect is Slow:
			# Slow effects are handled by the speed_multiplier() calculation
			pass
		
		# Update remaining time
		remaining_time -= step
		effect_data["remaining_time"] = remaining_time
		
		# If effect is done, remove it
		if remaining_time <= 0:
			active_effects.remove_at(i)
			# Clean up tracking for this effect
			if effect is Poison:
				effect_damage_owed.erase(effect)
		else:
			i += 1


func apply_poison_tick(effect: Poison, target: Node, delta: float) -> void:
	var health_node = target.get_node("Health")
	if not health_node or not health_node.has_method("damage"):
		return
	
	# Handle damage accumulation properly for this poison effect
	var total_damage = effect.damage_per_second * delta
	
	# Add to the current damage owed for this specific poison instance
	var owed = effect_damage_owed[effect] + total_damage
	var whole_damage = int(owed)
	
	if whole_damage > 0:
		health_node.damage(whole_damage)
	
	# Keep the fractional remainder for next tick
	effect_damage_owed[effect] = owed - whole_damage


func active_count() -> int:
	return active_effects.size()


func speed_multiplier() -> float:
	var multiplier = 1.0
	for effect_data in active_effects:
		var effect = effect_data["effect"]
		if effect is Slow:
			multiplier *= effect.multiplier
	
	return multiplier


func _physics_process(delta: float) -> void:
	tick(delta)