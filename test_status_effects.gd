extends Node

func _ready() -> void:
	# Test the status effects implementation
	test_poison_damage()
	test_slow_effect()
	test_multiple_effects()

func test_poison_damage() -> void:
	print("Testing poison damage...")
	
	# Create a player with health component
	var player = preload("res://scenes/player.tscn").instantiate()
	add_child(player)
	
	# Set up initial state
	player.status_effects.active_effects.clear()
	
	# Create a poison effect
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	# Add the poison
	player.status_effects.add(poison)
	
	# Apply ticks
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 98, "Expected 98 health after first tick")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 95, "Expected 95 health after second tick")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 93, "Expected 93 health after third tick")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 90, "Expected 90 health after fourth tick")
	
	# Check that effect is removed after duration
	player.status_effects.tick(0.5)
	assert(player.status_effects.active_count() == 0, "Expected no active effects after duration")
	assert(player.get_node("Health").current == 90, "Health should remain at 90")
	
	print("Poison damage test passed!")

func test_slow_effect() -> void:
	print("Testing slow effect...")
	
	# Create a player with health component
	var player = preload("res://scenes/player.tscn").instantiate()
	add_child(player)
	
	# Set up initial state
	player.status_effects.active_effects.clear()
	
	# Create a slow effect
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	# Add the slow
	player.status_effects.add(slow)
	
	# Check speed multiplier
	assert(player.status_effects.speed_multiplier() == 0.5, "Expected 0.5 speed multiplier")
	assert(player.effective_speed() == 100.0, "Expected effective speed of 100.0")
	
	# Apply half tick
	player.status_effects.tick(0.5)
	assert(player.status_effects.speed_multiplier() == 0.5, "Expected 0.5 speed multiplier after half tick")
	assert(player.effective_speed() == 100.0, "Expected effective speed of 100.0")
	
	# Apply remaining tick
	player.status_effects.tick(0.5)
	assert(player.status_effects.speed_multiplier() == 1.0, "Expected 1.0 speed multiplier after full duration")
	assert(player.effective_speed() == 200.0, "Expected effective speed of 200.0")
	
	print("Slow effect test passed!")

func test_multiple_effects() -> void:
	print("Testing multiple effects...")
	
	# Create a player with health component
	var player = preload("res://scenes/player.tscn").instantiate()
	add_child(player)
	
	# Set up initial state
	player.status_effects.active_effects.clear()
	
	# Add two poisons
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison1)
	player.status_effects.add(poison2)
	
	# Apply one tick (1 second)
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 90, "Expected 90 health after 1 second with two poisons")
	
	# Apply another tick (1 second)
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 80, "Expected 80 health after 2 seconds with two poisons")
	
	# Apply one more tick (1 second) - should still be 80
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 80, "Expected 80 health after 3 seconds")
	
	print("Multiple effects test passed!")