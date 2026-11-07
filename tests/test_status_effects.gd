extends Node

func test_poison_damage():
	# Create a player with health 100
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Add to scene tree for testing
	get_tree().root.add_child(player)
	
	# Test Poison damage over time
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	# Add poison to player's status effects
	player.status_effects.add(poison)
	
	# Tick 4 times with 0.5s each (total 2s) - should deal 10 damage
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 98, "Expected health 98 after first tick")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 95, "Expected health 95 after second tick")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 93, "Expected health 93 after third tick")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 90, "Expected health 90 after fourth tick")
	
	# Tick 2 more times (should still be at 90 since poison expired)
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 90, "Expected health 90 after fifth tick")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 90, "Expected health 90 after sixth tick")
	
	# Remove player from scene tree
	get_tree().root.remove_child(player)
	player.queue_free()
	print("Poison damage test passed")


func test_single_poison_tick():
	# Create a player with health 100
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Add to scene tree for testing
	get_tree().root.add_child(player)
	
	# Test single poison tick
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	
	# Apply one tick of 1 second
	poison.apply_tick(player, 1.0)
	assert(player.get_node("Health").current == 95, "Expected health 95 after 1s poison")
	
	# Remove player from scene tree
	get_tree().root.remove_child(player)
	player.queue_free()
	print("Single poison tick test passed")


func test_multiple_poisons():
	# Create a player with health 100
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Add to scene tree for testing
	get_tree().root.add_child(player)
	
	# Test two poisons of 5/s for 2s each
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison1)
	player.status_effects.add(poison2)
	
	# Tick 1s - should deal 10 damage (5 from each poison)
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 90, "Expected health 90 after first tick")
	
	# Tick 1s - should deal another 10 damage
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 80, "Expected health 80 after second tick")
	
	# Tick 1s - should deal another 10 damage (but only 20 left to deal from the first two ticks)
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 80, "Expected health 80 after third tick")
	
	# Remove player from scene tree
	get_tree().root.remove_child(player)
	player.queue_free()
	print("Multiple poisons test passed")


func test_slow_effect():
	# Create a player with speed 200
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Add to scene tree for testing
	get_tree().root.add_child(player)
	
	# Test slow effect
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	player.status_effects.add(slow)
	
	assert(player.status_effects.speed_multiplier() == 0.5, "Expected speed multiplier 0.5")
	assert(player.effective_speed() == 100.0, "Expected effective speed 100.0")
	
	# Tick 0.5s
	player.status_effects.tick(0.5)
	assert(player.status_effects.speed_multiplier() == 0.5, "Expected speed multiplier 0.5 after half tick")
	assert(player.effective_speed() == 100.0, "Expected effective speed 100.0")
	
	# Tick another 0.5s - should return to normal
	player.status_effects.tick(0.5)
	assert(player.status_effects.speed_multiplier() == 1.0, "Expected speed multiplier 1.0 after full tick")
	assert(player.effective_speed() == 200.0, "Expected effective speed 200.0")
	
	# Remove player from scene tree
	get_tree().root.remove_child(player)
	player.queue_free()
	print("Slow effect test passed")


func test_enemy_poison():
	# Create an enemy with health 100
	var enemy = preload("res://scenes/enemy.tscn").instantiate()
	
	# Add to scene tree for testing
	get_tree().root.add_child(enemy)
	
	# Test poison on enemy
	var poison = Poison.new()
	poison.damage_per_second = 4.0
	poison.duration = 1.0
	
	enemy.status_effects.add(poison)
	
	# Tick 1s - should deal 4 damage
	enemy.status_effects.tick(1.0)
	assert(enemy.get_node("Health").current == 96, "Expected enemy health 96 after poison")
	
	# Remove enemy from scene tree
	get_tree().root.remove_child(enemy)
	enemy.queue_free()
	print("Enemy poison test passed")


func _ready():
	test_poison_damage()
	test_single_poison_tick()
	test_multiple_poisons()
	test_slow_effect()
	test_enemy_poison()
	print("All tests passed!")