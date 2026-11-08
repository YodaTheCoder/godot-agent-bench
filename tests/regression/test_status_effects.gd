extends TestSuite

func test_poison_damage():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.name = "Player"
	# Add to scene tree to make sure health component works
	get_tree().root.add_child(player)
	
	# Test basic poison damage (5/s for 2s): tick 0.5 four times
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 98)
	
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 95)
	
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 93)
	
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 90)
	
	# Tick more to make sure it's done
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 90)
	
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 90)
	
	get_tree().root.remove_child(player)

func test_single_tick_poison():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.name = "Player"
	get_tree().root.add_child(player)
	
	# Test poison damage with single tick
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 1.0
	
	player.status_effects.add(poison)
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 95)
	
	get_tree().root.remove_child(player)

func test_multiple_poisons():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.name = "Player"
	get_tree().root.add_child(player)
	
	# Test two poisons of 5/s for 2s
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison1)
	player.status_effects.add(poison2)
	
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 90)
	
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 80)
	
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 80)
	
	get_tree().root.remove_child(player)

func test_slow_effect():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.name = "Player"
	get_tree().root.add_child(player)
	
	# Test slow effect (0.5 for 1s)
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	player.status_effects.add(slow)
	assert_eq(player.effective_speed(), 100.0)
	
	player.status_effects.tick(0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	player.status_effects.tick(0.5)
	assert_eq(player.effective_speed(), 200.0)
	assert_eq(player.status_effects.active_count(), 0)
	
	get_tree().root.remove_child(player)

func test_enemy_poison():
	var enemy = preload("res://scenes/enemy.tscn").instantiate()
	enemy.name = "Enemy"
	get_tree().root.add_child(enemy)
	
	# Test poison on enemy
	var poison = Poison.new()
	poison.damage_per_second = 4.0
	poison.duration = 1.0
	
	enemy.status_effects.add(poison)
	enemy.status_effects.tick(1.0)
	assert_eq(enemy.get_node("Health").current, 96)
	
	get_tree().root.remove_child(enemy)