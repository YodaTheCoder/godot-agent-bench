extends GutTest

func test_wave_config_defaults():
	var config = WaveConfig.new()
	assert_eq(config.enemy_scene, null)
	assert_eq(config.count, 1)
	assert_eq(config.interval, 1.0)

func test_wave_spawner_defaults():
	var spawner = WaveSpawner.new()
	assert_eq(spawner.wave_delay, 2.0)
	assert_eq(spawner.waves.size(), 0)

func test_spawn_waves():
	# Test that the wave spawner works correctly with basic functionality
	var enemy_scene = preload("res://scenes/enemy.tscn")
	
	var wave_config = WaveConfig.new()
	wave_config.enemy_scene = enemy_scene
	wave_config.count = 2
	wave_config.interval = 1.0
	
	var spawner = WaveSpawner.new()
	spawner.waves = [wave_config]
	
	# Start the spawner (this should not spawn enemies yet)
	spawner.start()
	
	# Check that we have not spawned enemies before first process call
	assert_eq(spawner.get_child_count(), 0)