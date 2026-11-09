extends GutTest

func test_default_fire_rate() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# First shot should always fire
	assert_true(weapon.try_fire(0.0))
	
	# Second shot at 0.2 seconds (should be blocked - only 0.2s passed, need 0.25s)
	assert_false(weapon.try_fire(0.2))
	
	# Shot at exactly 0.25 seconds should fire (minimum time reached)
	assert_true(weapon.try_fire(0.25))


func test_reset_clears_cooldown() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Fire at time 0
	assert_true(weapon.try_fire(0.0))
	
	# Reset should clear cooldown
	weapon.reset()
	
	# Should be able to fire immediately after reset
	assert_true(weapon.try_fire(0.0))
	
	# Next shot should be blocked due to cooldown
	assert_false(weapon.try_fire(0.125))


func test_reset_on_new_weapon() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Reset on a new weapon (never fired) should not cause issues
	weapon.reset()
	
	# Should be able to fire immediately after reset
	assert_true(weapon.try_fire(0.0))
	
	# Next shot should be blocked due to cooldown
	assert_false(weapon.try_fire(0.125))


func test_reset_with_different_times() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Fire at time 1.0
	assert_true(weapon.try_fire(1.0))
	
	# Reset should clear cooldown
	weapon.reset()
	
	# Should be able to fire immediately after reset (even with earlier time)
	assert_true(weapon.try_fire(1.0))
	
	# Next shot should be blocked due to cooldown
	assert_false(weapon.try_fire(1.125))
	
	# And then it should work again
	assert_true(weapon.try_fire(1.25))


func test_reset_with_earlier_time() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Fire at time 10.0
	assert_true(weapon.try_fire(10.0))
	
	# Reset should clear cooldown
	weapon.reset()
	
	# Should be able to fire even with an earlier time (3.0)
	assert_true(weapon.try_fire(3.0))


func test_fire_rate_changed() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Change fire rate to 2.0 shots per second
	weapon.fire_rate = 2.0
	
	# Reset should preserve fire_rate value
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)