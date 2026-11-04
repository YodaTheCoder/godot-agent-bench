extends TestSuite

func test_poison_damage_over_time():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	
	# Add player to scene tree for Health component to work
	get_tree().root.add_child(player)
	
	# Verify initial state
	assert_eq(player.status_effects.active_count(), 0)
	assert_eq(player.effective_speed(), 200.0)
	
	# Apply poison 5/s for 2s and tick 4 times with 0.5s each
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	
	# Tick 4 times of 0.5s each (total 2s) 
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 98)
	
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 95)
	
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 93)
	
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 90)
	
	# Verify no more active effects
	assert_eq(player.status_effects.active_count(), 0)
	
	# Tick 2 more times with 0.5s each (should not affect health anymore)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 90)
	
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 90)
	
	# Cleanup
	get_tree().root.remove_child(player)

func test_poison_single_tick():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	
	# Add player to scene tree for Health component to work
	get_tree().root.add_child(player)
	
	# Apply single poison tick of 1.0s
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	
	player.status_effects.add(poison)
	player.status_effects.tick(1.0)
	
	assert_eq(player.get_node("Health").current, 95) # 100 - 5 = 95
	
	# Cleanup
	get_tree().root.remove_child(player)

func test_multiple_poisons():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	
	# Add player to scene tree for Health component to work
	get_tree().root.add_child(player)
	
	# Apply two poisons of 5/s for 2s each
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison1)
	player.status_effects.add(poison2)
	
	# Tick 1.0s
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 90) # 100 - 10 = 90
	
	# Tick another 1.0s
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 80) # 90 - 10 = 80
	
	# Tick another 1.0s
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 80) # No change (both poisons expired)
	
	# Cleanup
	get_tree().root.remove_child(player)

func test_slow_effect():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	
	# Add player to scene tree for Health component to work
	get_tree().root.add_child(player)
	
	# Apply slow 0.5 for 1s
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	player.status_effects.add(slow)
	
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0) # 200 * 0.5 = 100
	
	# Tick 0.5s
	player.status_effects.tick(0.5)
	assert_eq(player.effective_speed(), 100.0) # Should still be the same
	
	# Tick another 0.5s (full duration)
	player.status_effects.tick(0.5)
	assert_eq(player.status_effects.speed_multiplier(), 1.0)
	assert_eq(player.effective_speed(), 200.0) # Back to normal
	
	# Cleanup
	get_tree().root.remove_child(player)

func test_multiple_slow_effects():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	
	# Add player to scene tree for Health component to work
	get_tree().root.add_child(player)
	
	# Apply slow 0.5 for 1s and 0.5 for 2s with speed = 300
	player.speed = 300.0
	
	var slow1 = Slow.new()
	slow1.multiplier = 0.5
	slow1.duration = 1.0
	
	var slow2 = Slow.new()
	slow2.multiplier = 0.5
	slow2.duration = 2.0
	
	player.status_effects.add(slow1)
	player.status_effects.add(slow2)
	
	assert_eq(player.status_effects.speed_multiplier(), 0.25) # 0.5 * 0.5 = 0.25
	assert_eq(player.effective_speed(), 75.0) # 300 * 0.25 = 75
	
	# Tick 1.0s
	player.status_effects.tick(1.0)
	assert_eq(player.effective_speed(), 150.0) # 300 * 0.5 = 150 (only slow2 still active)
	
	# Cleanup
	get_tree().root.remove_child(player)

func test_enemy_status_effects():
	var enemy = preload("res://scenes/enemy.tscn").instantiate()
	enemy.global_position = Vector2(0, 0)
	
	# Add enemy to scene tree for Health component to work
	get_tree().root.add_child(enemy)
	
	# Apply poison 4/s for 1s
	var poison = Poison.new()
	poison.damage_per_second = 4.0
	poison.duration = 1.0
	
	enemy.status_effects.add(poison)
	enemy.status_effects.tick(1.0)
	
	assert_eq(enemy.get_node("Health").current, 96) # 100 - 4 = 96
	
	# Cleanup
	get_tree().root.remove_child(enemy)

func test_defaults():
	var poison = Poison.new()
	var slow = Slow.new()
	var status_effects = StatusEffects.new()
	
	assert_eq(poison.duration, 1.0)
	assert_eq(poison.damage_per_second, 5.0)
	assert_eq(slow.duration, 1.0)
	assert_eq(slow.multiplier, 0.5)
	
	# Test that StatusEffects starts with no active effects
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	get_tree().root.add_child(player)
	
	assert_eq(player.status_effects.active_count(), 0)
	assert_eq(player.effective_speed(), 200.0)
	
	# Cleanup
	get_tree().root.remove_child(player)