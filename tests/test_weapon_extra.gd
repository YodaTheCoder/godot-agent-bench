extends GutTest

func test_default_fire_rate() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# First shot should always fire
	assert_true(weapon.try_fire(0.0))
	
	# Second shot too soon should be blocked
	assert_false(weapon.try_fire(0.2))
	
	# Shot at exact cooldown boundary should fire
	assert_true(weapon.try_fire(0.25))


func test_reset_clears_cooldown() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Fire at time 0
	assert_true(weapon.try_fire(0.0))
	
	# Reset the cooldown
	weapon.reset()
	
	# Should be able to fire immediately after reset
	assert_true(weapon.try_fire(0.0))


func test_reset_on_new_weapon() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Reset a weapon that never fired
	weapon.reset()
	
	# Should be able to fire immediately 
	assert_true(weapon.try_fire(0.0))
	
	# Next shot should be blocked due to cooldown
	assert_false(weapon.try_fire(0.125))


func test_reset_with_time_advance() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Fire at time 1.0
	assert_true(weapon.try_fire(1.0))
	
	# Reset the cooldown
	weapon.reset()
	
	# Should be able to fire immediately after reset
	assert_true(weapon.try_fire(1.0))
	
	# Next shot should be blocked due to cooldown
	assert_false(weapon.try_fire(1.125))
	
	# Shot at exact cooldown boundary should fire
	assert_true(weapon.try_fire(1.25))


func test_reset_with_earlier_time() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Fire at time 10.0
	assert_true(weapon.try_fire(10.0))
	
	# Reset the cooldown
	weapon.reset()
	
	# Should be able to fire even with earlier time
	assert_true(weapon.try_fire(3.0))


func test_fire_rate_change() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Change fire rate to 2.0 shots per second (0.5 seconds between shots)
	weapon.fire_rate = 2.0
	
	# Reset to make sure we're at start
	weapon.reset()
	
	# Should be able to fire immediately
	assert_true(weapon.try_fire(0.0))
	
	# Next shot should be blocked due to 0.5 second cooldown
	assert_false(weapon.try_fire(0.125))
	
	# Shot at exact cooldown boundary (0.5 seconds) should fire
	assert_true(weapon.try_fire(0.5))


func test_fire_rate_preserved_after_reset() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Change fire rate to 2.0 shots per second (0.5 seconds between shots)
	weapon.fire_rate = 2.0
	
	# Reset the cooldown
	weapon.reset()
	
	# Fire rate should still be 2.0
	assert_eq(weapon.fire_rate, 2.0)