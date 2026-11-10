extends GutTest

func test_poison_damage():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	
	# Add player to scene tree for Health component to work
	get_tree().root.add_child(player)
	
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	
	# Tick 4 times with 0.5s each = total 2s
	for i in range(4):
		player.status_effects.tick(0.5)
		
	# Should have taken 10 damage (5/s * 2s) 
	# First tick: 2.5 damage owed -> 2 dealt
	# Second tick: 2.5 + 2.5 = 5 damage owed -> 5 dealt  
	# Third tick: 5 + 2.5 = 7.5 damage owed -> 7 dealt (3 more)
	# Fourth tick: 7.5 + 2.5 = 10 damage owed -> 10 dealt (3 more)
	# Total dealt = 2 + 5 + 3 + 3 = 13
	# But health starts at 100, so it should be 87
	
	# Actually let's recheck the expected behavior:
	# With 5 damage/s for 2s, we get 10 total damage
	# In 0.5s steps: 
	# Step 1: 2.5 owed -> 2 dealt (health = 98)
	# Step 2: 2.5 + 2.5 = 5 owed -> 5 dealt (health = 93)  
	# Step 3: 5 + 2.5 = 7.5 owed -> 7 dealt (health = 86)
	# Step 4: 7.5 + 2.5 = 10 owed -> 10 dealt (health = 76)
	
	# Wait, let me re-read the requirement more carefully.
	# The example shows health 100->98->95->93->90 with 5/s for 2s
	# So 2+3+2+3 = 10 damage total, which matches 5/s * 2s
	
	# Let me just test that it works correctly:
	var expected_health = 90
	assert_eq(player.get_node("Health").current, expected_health)
	
	# Test that active_count is 0 after duration ends
	assert_eq(player.status_effects.active_count(), 0)
	
	player.queue_free()

func test_slow_effect():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	get_tree().root.add_child(player)
	
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	player.status_effects.add(slow)
	
	# Test speed multiplier
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	# Tick 0.5s
	player.status_effects.tick(0.5)
	
	# Should still be 100.0
	assert_eq(player.effective_speed(), 100.0)
	
	# Tick another 0.5s to complete the effect
	player.status_effects.tick(0.5)
	
	# Should return to normal speed
	assert_eq(player.status_effects.speed_multiplier(), 1.0)
	assert_eq(player.effective_speed(), 200.0)
	
	player.queue_free()

func test_multiple_effects():
	var player = preload("res://scenes/player.tscn").instantiate()
	player.global_position = Vector2(0, 0)
	get_tree().root.add_child(player)
	
	# Add two poisons of 5/s for 2s
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison1)
	player.status_effects.add(poison2)
	
	# Tick for 1 second
	player.status_effects.tick(1.0)
	
	# Should have taken 10 damage total (5/s * 2s * 2 poisons)  
	assert_eq(player.get_node("Health").current, 90)
	
	player.queue_free()