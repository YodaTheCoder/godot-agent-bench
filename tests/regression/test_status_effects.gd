extends Node

func test_poison_and_slow() -> void:
	# Create a player and add it to the scene tree
	var player = preload("res://scenes/player.tscn").instantiate()
	get_tree().root.add_child(player)
	
	# Verify initial state
	assert(player.status_effects.active_count() == 0)
	assert(player.effective_speed() == 200.0)
	
	# Create a Poison effect and add it with 5 damage per second for 2 seconds
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	
	# Tick 4 times with 0.5s each = 2 seconds total
	for i in range(4):
		player.status_effects.tick(0.5)
		assert(player.get_node("Health").current == 100 - (i + 1) * 2)
	
	# Verify poison is removed after 2 seconds
	assert(player.status_effects.active_count() == 0)
	
	# Add another poison
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison2)
	
	# One full tick with 3 seconds = should deal 5 * 2 = 10 damage (full duration)
	player.status_effects.tick(3.0)
	assert(player.get_node("Health").current == 90)
	assert(player.status_effects.active_count() == 0)
	
	# Test poison damage per second
	var poison3 = Poison.new()
	poison3.damage_per_second = 5.0
	poison3.duration = 1.0
	
	player.status_effects.add(poison3)
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 85)
	
	# Test two poisons
	var poison4 = Poison.new()
	poison4.damage_per_second = 5.0
	poison4.duration = 2.0
	
	var poison5 = Poison.new()
	poison5.damage_per_second = 5.0
	poison5.duration = 2.0
	
	player.status_effects.add(poison4)
	player.status_effects.add(poison5)
	
	# First tick of 1 second should deal 10 damage (5 from each poison)
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 75)
	
	# Second tick of 1 second should deal another 10
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 65)
	
	# Third tick of 1 second - should be empty now
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 65)
	
	# Test Slow effects
	var slow1 = Slow.new()
	slow1.multiplier = 0.5
	slow1.duration = 1.0
	
	player.status_effects.add(slow1)
	
	assert(player.status_effects.speed_multiplier() == 0.5)
	assert(player.effective_speed() == 100.0)
	
	# Tick 0.5 seconds
	player.status_effects.tick(0.5)
	assert(player.status_effects.speed_multiplier() == 0.5)
	assert(player.effective_speed() == 100.0)
	
	# Tick another 0.5 second to complete slow effect
	player.status_effects.tick(0.5)
	assert(player.status_effects.speed_multiplier() == 1.0)
	assert(player.effective_speed() == 200.0)
	
	# Test stacked slows
	var slow2 = Slow.new()
	slow2.multiplier = 0.5
	slow2.duration = 1.0
	
	var slow3 = Slow.new()
	slow3.multiplier = 0.5
	slow3.duration = 2.0
	
	player.status_effects.add(slow2)
	player.status_effects.add(slow3)
	
	assert(player.status_effects.speed_multiplier() == 0.25)
	assert(player.effective_speed() == 50.0)
	
	# Tick 1 second
	player.status_effects.tick(1.0)
	
	assert(player.status_effects.speed_multiplier() == 0.5)
	assert(player.effective_speed() == 100.0)
	
	# Test enemy poison
	var enemy = preload("res://scenes/enemy.tscn").instantiate()
	get_tree().root.add_child(enemy)
	
	# Add poison to enemy
	var poison6 = Poison.new()
	poison6.damage_per_second = 4.0
	poison6.duration = 1.0
	
	enemy.status_effects.add(poison6)
	player.status_effects.tick(1.0)
	assert(enemy.get_node("Health").current == 96)
	
	# Clean up
	get_tree().root.remove_child(player)
	get_tree().root.remove_child(enemy)