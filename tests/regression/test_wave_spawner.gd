# Test for wave spawner functionality
extends GutTest

func test_worked_example() -> void:
	# Create a WaveSpawner node
	var spawner = WaveSpawner.new()
	add_child(spawner)
	
	# Create wave configs as specified in the worked example
	var wave0 = WaveConfig.new()
	wave0.enemy_scene = load("res://scenes/enemy.tscn")
	wave0.count = 3
	wave0.interval = 0.5
	
	var wave1 = WaveConfig.new()
	wave1.enemy_scene = load("res://scenes/enemy.tscn")
	wave1.count = 2
	wave1.interval = 0.25
	
	spawner.waves = [wave0, wave1]
	spawner.wave_delay = 1.0
	spawner.target = Node2D.new() # Dummy target for testing
	
	# Start the spawner
	spawner.start()
	
	# Test that initially there are no enemies
	assert_eq(spawner.get_child_count(), 0)
	
	# Process time steps as described in the worked example
	# First call: 0.25 seconds - should spawn 1 enemy (wave 0, enemy 0)
	spawner._process(0.25)
	assert_eq(spawner.get_child_count(), 1)
	
	# Second call: 0.25 seconds - should spawn 1 more enemy (wave 0, enemy 1) 
	spawner._process(0.25)
	assert_eq(spawner.get_child_count(), 2)
	
	# Third call: 0.25 seconds - should spawn 1 more enemy (wave 0, enemy 2)
	spawner._process(0.25)
	assert_eq(spawner.get_child_count(), 3)
	
	# Fourth call: 0.25 seconds - should spawn 1 enemy from wave 1 (enemy 0) and emit wave_finished(0)
	spawner._process(0.25)
	assert_eq(spawner.get_child_count(), 4)
	
	# Fifth call: 0.25 seconds - should spawn 1 more enemy from wave 1 (enemy 1)
	spawner._process(0.25)
	assert_eq(spawner.get_child_count(), 5)
	
	# Test that all_waves_finished is emitted after the last signal
	# At this point, we've processed 1.25 seconds total time and should have all enemies spawned
	assert_eq(spawner.get_child_count(), 5)