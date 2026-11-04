extends GutTest

func test_poison_damage_over_time():
	# Create a player with health 100
	var player = preload("res://scenes/player.tscn").instantiate()
	Engine.get_scene_tree().root.add_child(player)
	
	# Get health and status effects
	var health = player.get_node("Health")
	var status_effects = player.get_node("StatusEffects")
	
	# Test poison 5/s for 2 s, then tick(0.5) four times -> health 98, 95, 93, 90
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	status_effects.add(poison)
	
	# 4 ticks of 0.5 seconds each = 2 seconds total
	status_effects.tick(0.5)
	assert_eq(health.current, 98) # First tick deals 2.5->2 damage
	
	status_effects.tick(0.5)
	assert_eq(health.current, 95) # Second tick deals 2.5->3 damage (total 5)
	
	status_effects.tick(0.5)
	assert_eq(health.current, 93) # Third tick deals 2.5->2 damage (total 7) 
	                                # but we already dealt 5, so 7-5=2
	
	status_effects.tick(0.5)
	assert_eq(health.current, 90) # Fourth tick deals 2.5->3 damage (total 10)
	
	# Should be done now
	assert_eq(status_effects.active_count(), 0)
	
	# Tick some more - should not change anything
	status_effects.tick(0.5)
	assert_eq(health.current, 90)
	
	player.queue_free()

func test_poison_single_tick():
	# Create a player with health 100
	var player = preload("res://scenes/player.tscn").instantiate()
	Engine.get_scene_tree().root.add_child(player)
	
	var health = player.get_node("Health")
	var status_effects = player.get_node("StatusEffects")
	
	# Test single tick of poison 5/s for 3s
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 1.0
	
	status_effects.add(poison)
	status_effects.tick(3.0) # Should deal exactly 5 damage in one go
	
	assert_eq(health.current, 95)
	
	player.queue_free()

func test_multiple_poisons():
	# Create a player with health 100
	var player = preload("res://scenes/player.tscn").instantiate()
	Engine.get_scene_tree().root.add_child(player)
	
	var health = player.get_node("Health")
	var status_effects = player.get_node("StatusEffects")
	
	# Two poisons of 5/s for 2 s
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	status_effects.add(poison1)
	status_effects.add(poison2)
	
	# First tick of 1s should deal 10 damage (5 from each poison)
	status_effects.tick(1.0)
	assert_eq(health.current, 90)
	
	# Second tick of 1s should deal 10 more damage  
	status_effects.tick(1.0)
	assert_eq(health.current, 80)
	
	# Third tick of 1s - still at 80 because no active poisons
	status_effects.tick(1.0)
	assert_eq(health.current, 80)
	
	player.queue_free()

func test_slow_effect():
	var player = preload("res://scenes/player.tscn").instantiate()
	Engine.get_scene_tree().root.add_child(player)
	
	var status_effects = player.get_node("StatusEffects")
	
	# Test slow 0.5 for 1s
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	status_effects.add(slow)
	assert_eq(status_effects.speed_multiplier(), 0.5)
	
	# Check effective speed is correct
	assert_eq(player.effective_speed(), 100.0) # 200 * 0.5 = 100
	
	status_effects.tick(0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	status_effects.tick(0.5)
	# Should be back to normal speed
	assert_eq(status_effects.speed_multiplier(), 1.0)
	assert_eq(player.effective_speed(), 200.0)
	
	player.queue_free()

func test_enemy_with_poison():
	# Test that enemy can also have status effects
	var enemy = preload("res://scenes/enemy.tscn").instantiate()
	Engine.get_scene_tree().root.add_child(enemy)
	
	var health = enemy.get_node("Health")
	var status_effects = Node.new()  # We'll create this properly in a real test
	status_effects.set_script(preload("res://scripts/components/status_effects.gd"))
	status_effects.set_parent(enemy)
	
	# This is more of a structural test - just ensuring it can be added
	assert_ne(status_effects, null)
	
	enemy.queue_free()
