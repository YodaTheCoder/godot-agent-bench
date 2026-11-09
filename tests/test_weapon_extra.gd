extends GutTest

func test_default_fire_rate() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# First shot should always fire
	assert_true(weapon.try_fire(0.0))
	
	# Second shot at 0.2 seconds (too early) should be blocked
	assert_false(weapon.try_fire(0.2))
	
	# Shot at 0.25 seconds (exactly the cooldown period) should fire
	assert_true(weapon.try_fire(0.25))


func test_reset_clears_cooldown() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Fire at time 0
	assert_true(weapon.try_fire(0.0))
	
	# Reset the weapon
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
	
	# Next shot at 0.125 seconds should be blocked (cooldown is 0.25 seconds)
	assert_false(weapon.try_fire(0.125))


func test_reset_with_time_shift() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Fire at time 1.0
	assert_true(weapon.try_fire(1.0))
	
	# Reset the weapon
	weapon.reset()
	
	# Should be able to fire immediately even with old time
	assert_true(weapon.try_fire(1.0))
	
	# Next shot at 1.125 should be blocked
	assert_false(weapon.try_fire(1.125))
	
	# Shot at 1.25 should fire
	assert_true(weapon.try_fire(1.25))


func test_reset_with_early_time() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Fire at time 10.0
	assert_true(weapon.try_fire(10.0))
	
	# Reset the weapon
	weapon.reset()
	
	# Should be able to fire even with earlier time
	assert_true(weapon.try_fire(3.0))


func test_fire_rate_change() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Change fire rate to 2.0 shots per second (0.5 seconds between shots)
	weapon.fire_rate = 2.0
	
	# Reset the weapon to clear any existing cooldown
	weapon.reset()
	
	# Fire rate should still be 2.0
	assert_eq(weapon.fire_rate, 2.0)


func test_reset_preserves_fire_rate() -> void:
	var weapon = Weapon.new()
	add_child_autofree(weapon)
	
	# Change fire rate to 2.0 shots per second
	weapon.fire_rate = 2.0
	
	# Reset the weapon
	weapon.reset()
	
	# Fire rate should still be 2.0
	assert_eq(weapon.fire_rate, 2.0)