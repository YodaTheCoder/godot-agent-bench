extends SceneTree

func _init() -> void:
	# Test status effects implementation 
	print("Starting Status Effects Tests...")
	
	# Create a test player
	var player_scene = preload("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	
	# Add to scene tree for testing
	get_root().add_child(player)
	
	# Should have StatusEffects component with 0 active effects and default speed
	assert(player.status_effects.active_count() == 0)
	assert(player.effective_speed() == 200.0)
	print("Basic player setup test passed")
	
	# Test Poison effect
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	
	# Tick once
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 98) # 100 - 2 = 98
	print("Poison tick test passed")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 95) # 98 - 3 = 95 
	print("Poison second tick test passed")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 93) # 95 - 2 = 93
	print("Poison third tick test passed")
	
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 90) # 93 - 3 = 90
	print("Poison fourth tick test passed")
	
	# All effects should be done now
	assert(player.status_effects.active_count() == 0)
	print("Poison complete test passed")
	
	# Test multiple poisons
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison2)
	player.status_effects.tick(1.0)
	assert(player.get_node("Health").current == 85) # 90 - 5 = 85 (first poison ticks for 1s, deals 5)
	print("Multiple poisons test passed")
	
	# Test Slow effect
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	player.status_effects.add(slow)
	assert(player.status_effects.speed_multiplier() == 0.5)
	assert(player.effective_speed() == 100.0) # 200 * 0.5 = 100
	print("Slow effect add test passed")
	
	player.status_effects.tick(0.5)
	assert(player.status_effects.speed_multiplier() == 0.5) # Still active
	assert(player.effective_speed() == 100.0)
	print("Slow half tick test passed")
	
	player.status_effects.tick(0.5)
	assert(player.status_effects.speed_multiplier() == 1.0) # Exceeded duration, removed
	assert(player.effective_speed() == 200.0)
	print("Slow complete tick test passed")
	
	# Test multiple slows
	slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	var slow2 = Slow.new()
	slow2.multiplier = 0.5
	slow2.duration = 2.0
	
	player.status_effects.add(slow)
	player.status_effects.add(slow2)
	assert(player.status_effects.speed_multiplier() == 0.25) # 0.5 * 0.5 = 0.25
	assert(player.effective_speed() == 50.0) # 200 * 0.25 = 50
	print("Multiple slow effects test passed")
	
	# Test with enemy
	var enemy_scene = preload("res://scenes/enemy.tscn")
	var enemy = enemy_scene.instantiate()
	get_root().add_child(enemy)
	
	var poison_enemy = Poison.new()
	poison_enemy.damage_per_second = 4.0
	poison_enemy.duration = 1.0
	
	enemy.get_node("StatusEffects").add(poison_enemy)
	enemy.get_node("StatusEffects").tick(1.0)
	assert(enemy.get_node("Health").current == 96) # 100 - 4 = 96
	print("Enemy poison test passed")
	
	# Cleanup
	get_root().remove_child(player)
	get_root().remove_child(enemy)
	
	print("All Status Effects tests passed successfully!")

func _process(_delta: float) -> void:
	quit()