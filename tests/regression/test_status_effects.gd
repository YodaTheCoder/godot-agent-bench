extends GutTest

func test_poison_damage():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.transform = Transform2D.IDENTITY.translated(Vector2(0, 0))
	
	# Add to scene tree so Health node is properly initialized
	get_tree().root.add_child(player)
	
	# Test basic poison damage
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	player.status_effects.add(poison)
	player.status_effects.tick(1.0)
	
	assert_eq(player.get_node("Health").current, 95)
	
	# Clean up
	player.queue_free()

func test_poison_over_time():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.transform = Transform2D.IDENTITY.translated(Vector2(0, 0))
	get_tree().root.add_child(player)
	
	# Add poison for 2 seconds at 5/s
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	player.status_effects.add(poison)
	
	# Tick in 0.5s increments four times
	for i in range(4):
		player.status_effects.tick(0.5)
	
	assert_eq(player.get_node("Health").current, 90)
	assert_eq(player.status_effects.active_count(), 0)
	
	# Tick more (should have no effect now)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 90)
	
	player.queue_free()

func test_slow_effect():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.transform = Transform2D.IDENTITY.translated(Vector2(0, 0))
	get_tree().root.add_child(player)
	
	# Test basic slow effect
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	player.status_effects.add(slow)
	
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	# Tick half the duration
	player.status_effects.tick(0.5)
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	# Tick remaining duration
	player.status_effects.tick(0.5)
	assert_eq(player.status_effects.speed_multiplier(), 1.0)
	assert_eq(player.effective_speed(), 200.0)
	
	player.queue_free()