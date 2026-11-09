# Test for WaveSpawner functionality
extends GutTest

func test_wave_config_defaults():
	var config = WaveConfig.new()
	assert_eq(config.enemy_scene, null)
	assert_eq(config.count, 1)
	assert_eq(config.interval, 1.0)

func test_wave_spawner_defaults():
	var spawner = WaveSpawner.new()
	assert_eq(spawner.waves.size(), 0)
	assert_eq(spawner.wave_delay, 2.0)
	assert_eq(spawner.autostart, false)

func test_before_start_nothing_spawns():
	var spawner = WaveSpawner.new()
	spawner.target = Node2D.new()
	
	# Test that nothing spawns before start() is called
	spawner._process(5.0)
	assert_eq(spawner.get_child_count(), 0)

func test_start_nothing_spawns():
	var spawner = WaveSpawner.new()
	spawner.target = Node2D.new()
	
	# Test that start() alone doesn't spawn anything
	spawner.start()
	spawner._process(0.1)
	assert_eq(spawner.get_child_count(), 0)