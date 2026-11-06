extends Node

func _ready() -> void:
	# Test case: Poison 5/s for 2 s, then tick(0.5) four times
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	var player = Player.new()
	player.speed = 200.0
	player.set_name("TestPlayer")
	
	# Create a StatusEffects component and add poison
	var status_effects = StatusEffects.new()
	status_effects.add(poison)
	
	# Tick four times with 0.5s intervals
	status_effects.tick(0.5)
	assert(player.get_node("Health").current == 98)
	
	status_effects.tick(0.5)
	assert(player.get_node("Health").current == 95)
	
	status_effects.tick(0.5)
	assert(player.get_node("Health").current == 93)
	
	status_effects.tick(0.5)
	assert(player.get_node("Health").current == 90)
	
	# Tick two more times (should not affect health since poison is done)
	status_effects.tick(0.5)
	assert(player.get_node("Health").current == 90)
	
	status_effects.tick(0.5)
	assert(player.get_node("Health").current == 90)
	
	print("All tests passed!")