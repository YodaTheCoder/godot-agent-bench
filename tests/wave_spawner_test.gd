extends TestSuite

func test_wave_spawner_timing():
	var spawner = WaveSpawner.new()
	spawner.waves = [
		WaveConfig.new(), # Default wave config with count=1, interval=1.0
		WaveConfig.new()  # Another default wave config
	]
	
	# Set up the waves to match the requirements
	var wave1 = WaveConfig.new()
	wave1.enemy_scene = preload("res://scenes/enemy.tscn")
	wave1.count = 3
	wave1.interval = 0.5
	
	var wave2 = WaveConfig.new()
	wave2.enemy_scene = preload("res://scenes/enemy.tscn")
	wave2.count = 2
	wave2.interval = 0.25
	
	spawner.waves = [wave1, wave2]
	
	# Test that before start nothing happens
	var initial_count = spawner.get_child_count()
	print("Initial enemies count: " + str(initial_count))
	
	# Test the specific example from requirements:
	# wave 0 = 3 enemies, interval = 0.5; wave 1 = 2 enemies, interval = 0.25; wave_delay = 1.0
	# Scheduled times: wave 0 at 0.0, 0.5, 1.0; wave 1 at 2.0, 2.25
	
	# Call _process with increasing deltas to match the requirements exactly
	spawner.start()
	
	# First call with delta=0.25: should spawn enemy 0 (time = 0.0) and 1 (time = 0.5)? No, it's just time 0.0
	assert_eq(spawner.get_child_count() - initial_count, 1) # Should have spawned the first enemy at 0.0
	
	# Call with delta 0.25 again so total elapsed is 0.5 - should spawn enemy 1 (time = 0.5)
	spawner._process(0.25)
	assert_eq(spawner.get_child_count() - initial_count, 2) # Should have spawned the second enemy at 0.5
	
	# Call with delta 0.25 again so total elapsed is 0.75 - should spawn enemy 2 (time = 1.0) and advance to wave 1
	spawner._process(0.25)
	assert_eq(spawner.get_child_count() - initial_count, 3) # Should have spawned the third enemy at 1.0
	
	# Call with delta 0.75 so total elapsed is 1.5 - should spawn first enemy of wave 1 at time = 2.0
	# This will not happen because our time schedule needs to be correct.
	spawner._process(0.75)
	assert_eq(spawner.get_child_count() - initial_count, 3) # Should still have 3 enemies
	
	SPAWN_DELAY = 1.0  # wave_delay = 1.0
	WAVE_0_END_TIME = (wave1.count - 1) * wave1.interval + SPAWN_DELAY  # 1.0 + 1.0 = 2.0
	print("Wave 0 should end at ", WAVE_0_END_TIME)
	
	var test_spawner = WaveSpawner.new()
	test_spawner.waves = [wave1, wave2]
	test_spawner.target = Node2D.new()
	test_spawner.start()
	
	# After the initial start: time=0.0, spawn 0 (time=0.0) -> count=1
	test_spawner._process(0.25)
	print("After first delta: ", test_spawner.get_child_count() - initial_count)
	
	# Second delta: time = 0.5, spawn 1 (time=0.5) -> count=2  
	test_spawner._process(0.25)
	print("After second delta: ", test_spawner.get_child_count() - initial_count) 
	
	# Third delta: time = 0.75, spawn 2 (time=1.0) -> count=3
	test_spawner._process(0.25)
	print("After third delta: ", test_spawner.get_child_count() - initial_count) 
	
	# Fourth delta: time = 1.0, wave 0 should finish, start of wave 1
	# Wave 1 starts at 1.0 + (3-1)*0.5 + 1.0 = 2.0, so first enemy at time 2.0
	test_spawner._process(0.25)
	print("After fourth delta: ", test_spawner.get_child_count() - initial_count) 
	
	# The following should not spawn anything because wave 0 is done and we haven't reached wave 1 yet (time 2.0)
	# The logic should be: when we reach end of wave 0, if the first enemy 
	test_spawner._process(0.25)
	print("After fifth delta: ", test_spawner.get_child_count() - initial_count)

func test_wave_config_defaults():
	var config = WaveConfig.new()
	assert_eq(config.enemy_scene, null)
	assert_eq(config.count, 1)
	assert_eq(config.interval, 1.0)

func test_wave_spawner_defaults():
	var spawner = WaveSpawner.new()
	assert_eq(spawner.wave_delay, 2.0)
	assert_eq(spawner.waves.size(), 0)