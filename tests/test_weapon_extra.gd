extends GutTest

func test_default_fire_rate() -> void:
	# With fire_rate = 4.0, shots should be allowed every 0.25 seconds (1/4)
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(0.2))  # Too early - 0.2 < 0.25
	assert_true(weapon.try_fire(0.25))  # Exactly right - 0.25 = 0.25

func test_reset_clears_cooldown() -> void:
	# Test that reset() clears the cooldown properly
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0))  # First shot
	weapon.reset()  # Reset should clear cooldown
	assert_true(weapon.try_fire(0.0))  # Should be allowed immediately after reset

func test_reset_on_new_weapon() -> void:
	# Test that reset() on a new weapon works (no previous shots)
	var weapon := Weapon.new()
	weapon.reset()  # Reset on new weapon should not cause issues
	assert_true(weapon.try_fire(0.0))  # Should be allowed immediately
	assert_false(weapon.try_fire(0.125))  # Should be blocked after first shot

func test_reset_with_time_passed() -> void:
	# Test reset with a time that's been passed
	var weapon := Weapon.new()
	weapon.try_fire(1.0)  # Shot at time 1.0
	weapon.reset()  # Reset should clear cooldown
	assert_true(weapon.try_fire(1.0))  # Should be allowed immediately even if same time
	assert_false(weapon.try_fire(1.125))  # Should be blocked after first shot

func test_reset_with_earlier_time() -> void:
	# Test reset with an earlier time than last shot
	var weapon := Weapon.new()
	weapon.try_fire(10.0)  # Shot at time 10.0
	weapon.reset()  # Reset should clear cooldown
	assert_true(weapon.try_fire(3.0))  # Should be allowed even with earlier time

func test_fire_rate_change() -> void:
	# Test that changing fire_rate works correctly after reset
	var weapon := Weapon.new()
	weapon.fire_rate = 2.0  # 2 shots per second, every 0.5 seconds
	weapon.reset()  # Reset the cooldown
	assert_true(weapon.try_fire(0.0))  # First shot should be allowed
	assert_false(weapon.try_fire(0.4))  # Should be blocked before 0.5 seconds
	assert_true(weapon.try_fire(0.5))  # Should be allowed after 0.5 seconds
	assert_equal(weapon.fire_rate, 2.0)  # Fire rate should not have changed

func test_multiple_resets() -> void:
	# Test multiple resets work correctly
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0))  # First shot
	weapon.reset()  # Reset
	assert_true(weapon.try_fire(0.1))  # Should be allowed immediately after reset
	weapon.reset()  # Reset again
	assert_true(weapon.try_fire(0.2))  # Should be allowed immediately after second reset

func test_reset_does_not_affect_fire_rate() -> void:
	# Test that reset doesn't change fire_rate value
	var weapon := Weapon.new()
	var initial_rate = weapon.fire_rate
	weapon.reset()  # Reset cooldown, not fire rate
	assert_equal(weapon.fire_rate, initial_rate)  # Fire rate should be unchanged