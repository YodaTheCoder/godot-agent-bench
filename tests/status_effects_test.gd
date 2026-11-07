extends Node

func test_poison_damage():
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Test that poison deals damage correctly over time
	var health_node = player.get_node("Health")
	health_node.current = 100
	
	# Apply poison for 2 seconds with 0.5 second ticks
	poison.apply_tick(player, 0.5)
	assert(health_node.current == 98) # 2.5 damage owed, so 2 dealt
	
	poison.apply_tick(player, 0.5)
	assert(health_node.current == 95) # 2.5 + 2.5 = 5.0, so 5 dealt
	
	poison.apply_tick(player, 0.5)
	assert(health_node.current == 93) # 5.0 + 2.5 = 7.5, so 7 dealt (2 more)
	
	poison.apply_tick(player, 0.5)
	assert(health_node.current == 90) # 7.5 + 2.5 = 10.0, so 10 dealt (3 more)
	
	# Verify poison is removed after duration
	var status_effects = player.get_node("StatusEffects")
	status_effects.add(poison)
	status_effects.tick(1.0)
	assert(status_effects.active_count() == 1) # Still active
	status_effects.tick(1.0)
	assert(status_effects.active_count() == 0) # Should be removed


func test_slow_effect():
	var slow = Slow.new()
	slow.multiplier = 0.5
	
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Test that slow affects speed correctly
	assert(player.effective_speed() == 200.0) # No slow effect
	
	player.get_node("StatusEffects").add(slow)
	assert(player.effective_speed() == 100.0) # 200 * 0.5
	
	player.get_node("StatusEffects").tick(0.5)
	assert(player.effective_speed() == 100.0) # Still slow
	
	player.get_node("StatusEffects").tick(0.5)
	assert(player.effective_speed() == 200.0) # Back to normal


func test_multiple_effects():
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	
	var player = preload("res://scenes/player.tscn").instantiate()
	var health_node = player.get_node("Health")
	health_node.current = 100
	
	# Test that two poisons stack
	player.get_node("StatusEffects").add(poison1)
	player.get_node("StatusEffects").add(poison2)
	
	player.get_node("StatusEffects").tick(1.0)
	assert(health_node.current == 90) # 5 + 5 = 10 damage dealt


func test_no_health():
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	
	var enemy = preload("res://scenes/enemy.tscn").instantiate()
	
	# Test that poison does nothing if target has no Health node
	poison.apply_tick(enemy, 1.0)
	
	# Should not crash or cause any issues


func test_speed_multiplier():
	var slow1 = Slow.new()
	slow1.multiplier = 0.5
	
	var slow2 = Slow.new()
	slow2.multiplier = 0.3
	
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Test that multiple slows multiply
	player.get_node("StatusEffects").add(slow1)
	player.get_node("StatusEffects").add(slow2)
	
	assert(player.effective_speed() == 60.0) # 200 * 0.5 * 0.3 = 30
	
	# Add a non-slow effect
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	player.get_node("StatusEffects").add(poison)
	
	assert(player.effective_speed() == 60.0) # Still 30, no change from poison


func test_duration_handling():
	var poison = Poison.new()
	poison.duration = 2.0
	poison.damage_per_second = 5.0
	
	var player = preload("res://scenes/player.tscn").instantiate()
	var health_node = player.get_node("Health")
	health_node.current = 100
	
	player.get_node("StatusEffects").add(poison)
	
	# Tick for 3 seconds total - should only apply for 2 seconds
	player.get_node("StatusEffects").tick(3.0)
	assert(health_node.current == 90) # 5 * 2 = 10 damage dealt


func test_tick_with_zero_duration():
	var poison = Poison.new()
	poison.duration = 0.0
	poison.damage_per_second = 5.0
	
	var player = preload("res://scenes/player.tscn").instantiate()
	var health_node = player.get_node("Health")
	health_node.current = 100
	
	player.get_node("StatusEffects").add(poison)
	
	# Tick for 1 second - should be removed immediately
	player.get_node("StatusEffects").tick(1.0)
	assert(health_node.current == 100) # No damage dealt
	assert(player.get_node("StatusEffects").active_count() == 0)