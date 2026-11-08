extends GutTest

func test_save_and_load():
	# Setup
	var player = preload("res://scenes/player.tscn").instantiate()
	player.position = Vector2(0, 0)
	
	ScoreManager.score = 120
	player.get_node("Health").current = 35
	
	# Save
	var save_path = "user://test_save.tres"
	var error = SaveGame.save(player, save_path)
	
	# Verify save was successful
	assert_eq(error, OK)
	
	# Verify file exists
	assert_true(ResourceLoader.exists(save_path))
	
	# Load into new player instance to verify data
	var new_player = preload("res://scenes/player.tscn").instantiate()
	new_player.position = Vector2(0, 0)
	
	var success = SaveGame.load_into(new_player, save_path)
	
	# Verify load was successful
	assert_true(success)
	
	# Verify data was restored correctly
	assert_eq(ScoreManager.score, 120)
	assert_eq(new_player.get_node("Health").current, 35)
	
	# Test loading non-existent file
	var missing_file_success = SaveGame.load_into(player, "user://does_not_exist.tres")
	assert_false(missing_file_success)
	
	# Test that score and health were not changed by failed load
	assert_eq(ScoreManager.score, 120)
	assert_eq(player.get_node("Health").current, 35)

func test_save_default_path():
	# Setup
	var player = preload("res://scenes/player.tscn").instantiate()
	player.position = Vector2(0, 0)
	
	ScoreManager.score = 120
	player.get_node("Health").current = 35
	
	# Save with default path
	var error = SaveGame.save(player)
	assert_eq(error, OK)
	
	# Load with default path
	var success = SaveGame.load_into(player)
	assert_true(success)
	
	assert_eq(ScoreManager.score, 120)
	assert_eq(player.get_node("Health").current, 35)

func test_load_invalid_file():
	# Create a dummy file that's not a SaveData resource
	var dummy_path = "user://dummy.tres"
	var dummy_resource = Resource.new()
	ResourceSaver.save(dummy_resource, dummy_path)
	
	# Setup player
	var player = preload("res://scenes/player.tscn").instantiate()
	player.position = Vector2(0, 0)
	ScoreManager.score = 100
	player.get_node("Health").current = 50
	
	# Try to load invalid file
	var success = SaveGame.load_into(player, dummy_path)
	assert_false(success)
	
	# Verify that score and health were not changed
	assert_eq(ScoreManager.score, 100)
	assert_eq(player.get_node("Health").current, 50)