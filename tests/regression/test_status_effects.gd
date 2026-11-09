extends GutTest

func test_poison_effect() -> void:
	var player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Test poison damage calculation
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	player.status_effects.add(poison)
	
	# Tick for 2 seconds (should deal 10 damage total)
	player.status_effects.tick(3.0)
	
	assert_eq(player.get_node("Health").current, 90)
	assert_eq(player.status_effects.active_count(), 0)


func test_slow_effect() -> void:
	var player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Test slow effect
	var slow = Slow.new()
	slow.multiplier = 0.5
	player.status_effects.add(slow)
	
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	# Tick for 1 second (should remove the effect)
	player.status_effects.tick(1.0)
	
	assert_eq(player.status_effects.speed_multiplier(), 1.0)
	assert_eq(player.effective_speed(), 200.0)


func test_multiple_effects() -> void:
	var player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Add two poisons
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	player.status_effects.add(poison1)
	
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	player.status_effects.add(poison2)
	
	# Tick for 1 second (should deal 10 damage total)
	player.status_effects.tick(1.0)
	
	assert_eq(player.get_node("Health").current, 90)
	assert_eq(player.status_effects.active_count(), 2)
	
	# Tick for another second (should deal another 10 damage)
	player.status_effects.tick(1.0)
	
	assert_eq(player.get_node("Health").current, 80)
	assert_eq(player.status_effects.active_count(), 2)
	
	# Tick for another second (should deal another 10 damage, but effects end)
	player.status_effects.tick(1.0)
	
	assert_eq(player.get_node("Health").current, 70)
	assert_eq(player.status_effects.active_count(), 0)


func test_enemy_poison() -> void:
	var enemy = add_child_autofree(load("res://scenes/enemy.tscn").instantiate())
	
	# Test poison on enemy
	var poison = Poison.new()
	poison.damage_per_second = 4.0
	enemy.get_node("StatusEffects").add(poison)
	
	# Tick for 1 second (should deal 4 damage)
	enemy.get_node("StatusEffects").tick(1.0)
	
	assert_eq(enemy.get_node("Health").current, 96)