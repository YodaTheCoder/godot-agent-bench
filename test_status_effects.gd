extends Node

func _ready() -> void:
	# Test the acceptance criteria for our implementation
	
	# Create a player and add status effects component
	var player_scene = preload("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	player.position = Vector2(0, 0)
	add_child(player)
	
	# Verify initial state
	assert(player.status_effects.active_count() == 0)
	assert(player.effective_speed() == 200.0)
	print("Initial state correct")
	
	# Test Poison damage over time behavior with step-by-step ticks
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	
	player.status_effects.add(poison)
	
	# Apply tick for 0.5 seconds (should deal 2.5 damage, so 2 points)
	player.status_effects.tick(0.5)  
	assert(player.get_node("Health").current == 98)
	print("After first tick with 0.5s: health = %s" % player.get_node("Health").current)
	
	# Apply another 0.5 seconds (should deal 2.5 more damage, so 2 more points)
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 96)
	print("After second tick with 0.5s: health = %s" % player.get_node("Health").current)
	
	# Apply another 0.5 seconds (should deal 2.5 more damage, so 2 more points)
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 94)
	print("After third tick with 0.5s: health = %s" % player.get_node("Health").current)

	# Apply another 0.5 seconds (should deal 2.5 more damage, so 2 more points)
	player.status_effects.tick(0.5)
	assert(player.get_node("Health").current == 92)
	print("After fourth tick with 0.5s: health = %s" % player.get_node("Health").current)
	
	# All effects should be completed now
	assert(player.status_effects.active_count() == 0)
	print("All effects removed after full duration")
	
	print("Poison damage over time test passed!")

func _process(_delta: float) -> void:
	pass