# Test for save/load functionality
extends "res://addons/gut/test.gd"

func test_save_and_load():
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Set up initial state
	ScoreManager.score = 120
	player.get_node("Health").current = 35
	
	# Test saving
	var error = SaveGame.save(player)
	assert_eq(error, OK, "Save should succeed")
	
	# Verify file was created
	assert_true(ResourceLoader.exists("user://save.tres"), "Save file should exist")
	
	# Test loading
	var result = SaveGame.load_into(player)
	assert_eq(result, true, "Load should succeed")
	
	# Verify values were restored
	assert_eq(ScoreManager.score, 120, "Score should be restored")
	assert_eq(player.get_node("Health").current, 35, "Health should be restored")
	
	# Test loading from specific path
	ScoreManager.score = 0
	player.get_node("Health").current = 0
	
	var result2 = SaveGame.load_into(player, "user://save.tres")
	assert_eq(result2, true, "Load from specific path should succeed")
	assert_eq(ScoreManager.score, 120, "Score should be restored from specific path")
	assert_eq(player.get_node("Health").current, 35, "Health should be restored from specific path")
	
	# Test loading non-existent file
	var result3 = SaveGame.load_into(player, "user://does_not_exist.tres")
	assert_eq(result3, false, "Loading non-existent file should return false")
	
	# Verify state unchanged
	assert_eq(ScoreManager.score, 120, "Score should remain unchanged when loading failed")
	assert_eq(player.get_node("Health").current, 35, "Health should remain unchanged when loading failed")
	
	player.queue_free()