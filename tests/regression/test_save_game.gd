extends GutTest

func before_each() -> void:
	ScoreManager.reset()

func after_each() -> void:
	ScoreManager.reset()

func test_save_load() -> void:
	# Set up a player with health
	var player = Player.new()
	player.name = "Player"
	
	# Add a health node to the player
	var health = Health.new()
	health.name = "Health"
	health.max_health = 100
	health.current = 35
	player.add_child(health)
	
	# Set up score
	ScoreManager.add_points(120)
	
	# Test save function
	var error = SaveGame.save(player, "user://test_save.tres")
	assert_eq(error, OK)
	
	# Check that file was created
	assert_true(ResourceLoader.exists("user://test_save.tres"))
	
	# Load and check data
	var data = ResourceLoader.load("user://test_save.tres", "", ResourceLoader.CACHE_MODE_IGNORE)
	assert_is_instance_of(data, SaveData)
	assert_eq(data.score, 120)
	assert_eq(data.player_health, 35)
	assert_eq(data.inventory, {})
	
	# Change values to make sure load restores them
	ScoreManager.add_points(10)
	health.current = 20
	
	# Test load_into function
	var success = SaveGame.load_into(player, "user://test_save.tres")
	assert_true(success)
	assert_eq(ScoreManager.score, 120)
	assert_eq(health.current, 35)
	
	# Test loading non-existent file
	success = SaveGame.load_into(player, "user://does_not_exist.tres")
	assert_false(success)
	assert_eq(ScoreManager.score, 120) # Should not have changed
	assert_eq(health.current, 35) # Should not have changed

func test_default_paths() -> void:
	var player = Player.new()
	player.name = "Player"
	
	var health = Health.new()
	health.name = "Health"
	health.max_health = 100
	health.current = 50
	player.add_child(health)
	
	ScoreManager.add_points(200)
	
	# Test using default paths
	var error = SaveGame.save(player)
	assert_eq(error, OK)
	
	var success = SaveGame.load_into(player)
	assert_true(success)
	assert_eq(ScoreManager.score, 200)
	assert_eq(health.current, 50)