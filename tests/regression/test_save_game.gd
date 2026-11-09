extends GutTest

func before_each() -> void:
	ScoreManager.reset()
	
	# Create a simple test player with health component
	var player_scene = preload("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	player.name = "Player"
	
	# Add to scene for testing
	get_tree().root.add_child(player)
	
	# Set up the player's health
	player.get_node("Health").current = 100
	
	# Store reference for cleanup
	_test_player = player


func after_each() -> void:
	ScoreManager.reset()
	
	if _test_player and _test_player.is_inside_tree():
		_test_player.queue_free()


func test_save_and_load() -> void:
	# Set up initial state
	ScoreManager.score = 120
	var player = _test_player
	player.get_node("Health").current = 35
	
	# Save the game
	var error = SaveGame.save(player, "user://test_save.tres")
	assert_eq(error, OK)
	
	# Verify file was created
	assert_true(ResourceLoader.exists("user://test_save.tres"))
	
	# Load the game back
	var success = SaveGame.load_into(player, "user://test_save.tres")
	assert_true(success)
	
	# Verify state was restored
	assert_eq(ScoreManager.score, 120)
	assert_eq(player.get_node("Health").current, 35)


func test_load_nonexistent_file() -> void:
	var player = _test_player
	
	# Try to load from non-existent file
	var success = SaveGame.load_into(player, "user://does_not_exist.tres")
	assert_false(success)
	
	# Verify state wasn't changed
	assert_eq(ScoreManager.score, 0)
	assert_eq(player.get_node("Health").current, 100)


func test_save_and_load_default_path() -> void:
	# Set up initial state
	ScoreManager.score = 250
	var player = _test_player
	player.get_node("Health").current = 75
	
	# Save with default path
	var error = SaveGame.save(player)
	assert_eq(error, OK)
	
	# Load with default path
	var success = SaveGame.load_into(player)
	assert_true(success)
	
	# Verify state was restored
	assert_eq(ScoreManager.score, 250)
	assert_eq(player.get_node("Health").current, 75)