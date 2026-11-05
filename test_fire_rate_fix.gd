extends GutTest

func test_default_fire_rate_4() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Default fire_rate = 4.0 means 4 shots per second (every 0.25 seconds)
	assert_true(weapon.try_fire(0.0)) # First shot allowed
	assert_false(weapon.try_fire(0.2)) # Too soon - should be blocked 
	assert_true(weapon.try_fire(0.25)) # Should be allowed after 0.25 seconds


func test_fire_rate_2() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	weapon.fire_rate = 2.0
	
	# fire_rate = 2.0 means 2 shots per second (every 0.5 seconds)
	assert_true(weapon.try_fire(0.0)) # First shot allowed
	assert_false(weapon.try_fire(0.4)) # Too soon - should be blocked
	assert_true(weapon.try_fire(0.5)) # Should be allowed after 0.5 seconds


func test_fire_rate_0_5() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	weapon.fire_rate = 0.5
	
	# fire_rate = 0.5 means 0.5 shots per second (every 2.0 seconds)
	assert_true(weapon.try_fire(0.0)) # First shot allowed
	assert_false(weapon.try_fire(1.5)) # Too soon - should be blocked
	assert_true(weapon.try_fire(2.0)) # Should be allowed after 2.0 seconds


func test_first_shot_always_allowed() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# First shot should always be allowed regardless of time
	assert_true(weapon.try_fire(100.0))