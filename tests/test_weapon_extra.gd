extends GutTest

func test_default_fire_rate() -> void:
	# With default fire_rate = 4.0, shots should be allowed every 0.25 seconds (1/4)
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0)) # First shot always allowed
	assert_false(weapon.try_fire(0.2)) # Too soon - should be blocked
	assert_true(weapon.try_fire(0.25)) # Exactly 0.25 seconds - should be allowed


func test_reset_clears_cooldown() -> void:
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0)) # First shot
	weapon.reset() # Reset the cooldown
	assert_true(weapon.try_fire(0.0)) # Should be allowed immediately after reset


func test_reset_on_new_weapon() -> void:
	var weapon := Weapon.new()
	weapon.reset() # Reset a weapon that never fired
	assert_true(weapon.try_fire(0.0)) # Should be allowed
	assert_false(weapon.try_fire(0.125)) # Too soon - should be blocked


func test_reset_with_time_shift() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(1.0) # Fire at time 1.0
	weapon.reset() # Reset the cooldown
	assert_true(weapon.try_fire(1.0)) # Should be allowed even with same time
	assert_false(weapon.try_fire(1.125)) # Too soon - should be blocked
	assert_true(weapon.try_fire(1.25)) # Should be allowed after 0.125 seconds


func test_reset_with_earlier_time() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(10.0) # Fire at time 10.0
	weapon.reset() # Reset the cooldown
	assert_true(weapon.try_fire(3.0)) # Should be allowed even with earlier time


func test_fire_rate_change() -> void:
	var weapon := Weapon.new()
	weapon.fire_rate = 2.0 # Change to 2 shots per second (0.5 seconds between)
	weapon.reset() # Reset to make sure we're at start
	assert_true(weapon.try_fire(0.0)) # Should be allowed
	assert_false(weapon.try_fire(0.4)) # Too soon - should be blocked
	assert_true(weapon.try_fire(0.5)) # Should be allowed after 0.5 seconds


func test_fire_rate_preserved_after_reset() -> void:
	var weapon := Weapon.new()
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0) # Fire rate should be unchanged


func test_first_shot_always_allowed() -> void:
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(123.456)) # First shot always allowed even with large time


func test_boundary_conditions() -> void:
	# Test that exactly 1/fire_rate seconds is allowed
	var weapon := Weapon.new()
	weapon.fire_rate = 8.0 # 8 shots per second means 0.125 seconds between
	assert_true(weapon.try_fire(0.0)) # First shot
	assert_false(weapon.try_fire(0.1)) # Too soon
	assert_true(weapon.try_fire(0.125)) # Exactly right - should be allowed


func test_multiple_resets() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(0.0)
	weapon.reset()
	weapon.reset()
	assert_true(weapon.try_fire(0.0))