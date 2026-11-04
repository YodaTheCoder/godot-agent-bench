class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

func apply_tick(target: Node, delta: float) -> void:
	# Check if the target has a Health child
	if not target.has_node("Health"):
		return
		
	var health = target.get_node("Health")
	
	# Create a unique key based on both the poison instance and target
	# So each instance of Poison keeps its own tracking 
	var poison_key = "poison_damage_accumulated_" + str(self.get_instance_id()) + "_" + str(target.get_instance_id())
	
	if not target.has_meta(poison_key):
		target.set_meta(poison_key, 0.0)
		
	var accumulated_damage = target.get_meta(poison_key)
	accumulated_damage += damage_per_second * delta
	var damage_to_deal = int(accumulated_damage)
	
	if damage_to_deal > 0:
		health.damage(damage_to_deal)
		accumulated_damage -= damage_to_deal
		
	target.set_meta(poison_key, accumulated_damage)
