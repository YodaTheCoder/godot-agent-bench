extends GutTest

func test_poison_effect() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Test poison damage
	var poison := Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	
	# Tick 4 times with 0.5s each = 2 seconds total
	for i in range(4):
		player.status_effects.tick(0.5)
		assert_eq(player.get_node("Health").current, 100 - (i + 1) * 2) # damage 2 each time
	
	# Should be at 90 health now and no active effects
	assert_eq(player.get_node("Health").current, 90)
	assert_eq(player.status_effects.active_count(), 0)


func test_slow_effect() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Test slow effect
	var slow := Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	player.status_effects.add(slow)
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	player.status_effects.tick(0.5)
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	player.status_effects.tick(0.5)
	assert_eq(player.status_effects.speed_multiplier(), 1.0)
	assert_eq(player.effective_speed(), 200.0)


func test_multiple_effects() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Test two poisons
	var poison1 := Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	
	var poison2 := Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison1)
	player.status_effects.add(poison2)
	
	# Tick for 3 seconds (should get 10 damage total from both poisons)
	player.status_effects.tick(3.0)
	assert_eq(player.get_node("Health").current, 90) # 100 - 10
	assert_eq(player.status_effects.active_count(), 0)


func test_enemy_status_effects() -> void:
	var enemy: Enemy = add_child_autofree(load("res://scenes/enemy.tscn").instantiate())
	
	# Test poison on enemy
	var poison := Poison.new()
	poison.damage_per_second = 4.0
	poison.duration = 1.0
	
	enemy.status_effects.add(poison)
	enemy.status_effects.tick(1.0)
	
	assert_eq(enemy.get_node("Health").current, 96) # 100 - 4


func test_speed_multiplier_calculation() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	
	# Test with multiple slows
	var slow1 := Slow.new()
	slow1.multiplier = 0.5
	slow1.duration = 1.0
	
	var slow2 := Slow.new()
	slow2.multiplier = 0.5
	slow2.duration = 2.0
	
	player.status_effects.add(slow1)
	player.status_effects.add(slow2)
	
	assert_eq(player.status_effects.speed_multiplier(), 0.25) # 0.5 * 0.5
	assert_eq(player.effective_speed(), 75.0)
	
	player.status_effects.tick(1.0)
	assert_eq(player.status_effects.speed_multiplier(), 0.5) # Only second slow effect remains
	assert_eq(player.effective_speed(), 100.0)