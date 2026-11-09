extends GutTest

func test_worked_example() -> void:
	# Worked example: wave 0 = 3 enemies, interval = 0.5; wave 1 = 2 enemies, interval = 0.25; wave_delay = 1.0
	# Scheduled times: wave 0 at 0.0, 0.5, 1.0; wave 1 at 2.0, 2.25
	
	var spawner = WaveSpawner.new()
	add_child(spawner)
	
	# Setup waves with the example values
	var wave_config_0 = WaveConfig.new()
	wave_config_0.enemy_scene = preload("res://scenes/enemy.tscn")
	wave_config_0.count = 3
	wave_config_0.interval = 0.5
	
	var wave_config_1 = WaveConfig.new()
	wave_config_1.enemy_scene = preload("res://scenes/enemy.tscn")
	wave_config_1.count = 2
	wave_config_1.interval = 0.25
	
	spawner.waves = [wave_config_0, wave_config_1]
	spawner.wave_delay = 1.0
	spawner.autostart = false
	spawner.target = null
	
	# Start the spawner
	spawner.start()
	
	# Test each step in the worked example
	var enemy_count = 0
	var wave_0_finished = false 
	var wave_1_finished = false
	var all_finished = false
	
	# Call _process(0.25) ten times - this should follow the worked example:
	# After 1st call: 1 enemy (time 0.0)
	# After 2nd call: 2 enemies (time 0.5) 
	# After 3rd call: 2 enemies (time 1.0) - still waiting to emit wave_finished(0)
	# After 4th call: 3 enemies (wave_finished(0) emitted at time 1.0, next enemy spawns) 
	# After 5th call: 3 enemies (wave_finished(0) already emitted)
	# After 6th call: 3 enemies (wave_finished(0) already emitted)
	# After 7th call: 3 enemies (wave_finished(0) already emitted)
	# After 8th call: 4 enemies (time 2.0, first enemy of wave 1 spawns)
	# After 9th call: 5 enemies (time 2.25, second enemy of wave 1 spawns)
	# After 10th call: 5 enemies (all_waves_finished emitted at this point)
	
	var wave_count = 0
	var all_waves_count = 0
	
	spawner.wave_finished.connect(func(index):
		wave_count = index
		print("Wave %d finished" % index)
	)
	
	spawner.all_waves_finished.connect(func():
		all_waves_count += 1
		print("All waves finished")
	)
		
	for i in range(10):
		spawner._process(0.25)
		var current_enemies = spawner.get_child_count()
		
		match i + 1:
			1: assert_eq(current_enemies, 1)
			2: assert_eq(current_enemies, 2) 
			3: assert_eq(current_enemies, 2)
			4: assert_eq(current_enemies, 3)
			5: assert_eq(current_enemies, 3)
			6: assert_eq(current_enemies, 3)
			7: assert_eq(current_enemies, 3)
			8: assert_eq(current_enemies, 4)
			9: assert_eq(current_enemies, 5) 
			10: assert_eq(current_enemies, 5)
			
	# Verify signals
	assert_eq(wave_count, 1)  # wave 1 should be finished (last wave)
	assert_eq(all_waves_count, 1)  # all waves finished should be emitted

func test_basic_spawn() -> void:
	var spawner = WaveSpawner.new()
	add_child(spawner)
	
	var config = WaveConfig.new()
	config.enemy_scene = preload("res://scenes/enemy.tscn")
	config.count = 2
	config.interval = 1.0
	
	spawner.waves = [config]
	spawner.autostart = false
	spawner.target = null
	
	# Start the spawner  
	spawner.start()
	
	# Test that we start with no enemies
	assert_eq(spawner.get_child_count(), 0)
	
	# Process some time to spawn enemies
	spawner._process(1.5)
	assert_eq(spawner.get_child_count(), 2)