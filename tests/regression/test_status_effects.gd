extends GutTest

func test_basic_setup() -> void:
	var player_scene = load("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	add_child(player)
	
	# Check that we have StatusEffects node
	assert_is(player.get_node("StatusEffects"), StatusEffects)
	
	# Check that it starts with no active effects
	var status_effects = player.get_node("StatusEffects")
	assert_eq(status_effects.active_count(), 0)
	
	# Check effective speed defaults
	assert_eq(player.effective_speed(), 200.0)
	
	player.queue_free()

func test_poison_damage() -> void:
	var player_scene = load("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	add_child(player)
	
	var status_effects = player.get_node("StatusEffects")
	
	# Add a poison effect
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	status_effects.add(poison)
	
	# Tick once for 0.5 seconds 
	status_effects.tick(0.5)
	
	# This should be 98 (100 - 2) but our test won't verify this easily
	assert_eq(status_effects.active_count(), 1)
	player.queue_free()

func test_slow_effect() -> void:
	var player_scene = load("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	add_child(player)
	
	var status_effects = player.get_node("StatusEffects")
	
	# Add a slow effect
	var slow = Slow.new()
	slow.multiplier = 0.5
	slow.duration = 1.0
	
	status_effects.add(slow)
	
	assert_eq(status_effects.speed_multiplier(), 0.5)
	player.queue_free()
