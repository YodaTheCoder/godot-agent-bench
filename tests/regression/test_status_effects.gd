extends GutTest

func test_poison_damage():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	get_tree().root.add_child(player)
	
	# Test poison damage over time
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	
	# Tick 4 times with 0.5s each
	for i in range(4):
		player.status_effects.tick(0.5)
		
		var health_current = player.get_node("Health").current
		if i == 0:
			assert_eq(health_current, 98) # 100 - 2 (first damage)
		elif i == 1:
			assert_eq(health_current, 95) # 98 - 3 (second damage)
		elif i == 2:
			assert_eq(health_current, 93) # 95 - 2 (third damage)
		elif i == 3:
			assert_eq(health_current, 90) # 93 - 3 (fourth damage)
	
	# After all effects should be gone
	assert_eq(player.status_effects.active_count(), 0)

func test_single_poison_tick():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	get_tree().root.add_child(player)
	
	# Test single tick with full damage
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 1.0
	
	player.status_effects.add(poison)
	player.status_effects.tick(1.0) # Full duration
	
	assert_eq(player.get_node("Health").current, 95)

func test_multiple_poisons():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	get_tree().root.add_child(player)
	
	# Test two poisons
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison1)
	player.status_effects.add(poison2)
	
	# Tick 3 times with 1s each (should deal 10 each, total 20)
	for i in range(3):
		player.status_effects.tick(1.0)
		
		var health_current = player.get_node("Health").current
		if i == 0:
			assert_eq(health_current, 90) # 100 - 10 (first poison only)
		elif i == 1:
			assert_eq(health_current, 80) # 90 - 10 (second poison)
		elif i == 2:
			assert_eq(health_current, 80) # Already at 80
	
	assert_eq(player.status_effects.active_count(), 0)

func test_slow_effect():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	get_tree().root.add_child(player)
	
	# Test slow effect
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	player.status_effects.add(slow)
	
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0) # 200 * 0.5
	
	player.status_effects.tick(0.5)
	assert_eq(player.effective_speed(), 100.0) # Still 100.0
	
	player.status_effects.tick(0.5)
	assert_eq(player.status_effects.speed_multiplier(), 1.0)
	assert_eq(player.effective_speed(), 200.0) # Back to normal

func test_enemy_poison():
	var enemy = preload("res://scenes/enemy.tscn").instantiate()
	enemy.global_position = Vector2(0, 0)
	get_tree().root.add_child(enemy)
	
	# Test poison on enemy
	var poison = Poison.new()
	poison.damage_per_second = 4.0
	poison.duration = 1.0
	
	enemy.status_effects.add(poison)
	enemy.status_effects.tick(1.0) # Full duration
	
	assert_eq(enemy.get_node("Health").current, 96) # 100 - 4

func test_default_values():
	var poison = Poison.new()
	var slow = Slow.new()
	var status_effect = StatusEffect.new()
	
	assert_eq(poison.duration, 1.0)
	assert_eq(poison.damage_per_second, 5.0)
	assert_eq(slow.duration, 1.0)
	assert_eq(slow.multiplier, 0.5)
	assert_eq(status_effect.duration, 1.0)