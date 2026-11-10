extends GutTest

func test_default_fire_rate() -> void:
	# Default fire_rate = 4.0 means 1 shot every 0.25 seconds (1/4)
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(0.2))  # Too early - only 0.2 seconds passed
	assert_true(weapon.try_fire(0.25))  # Exactly 0.25 seconds - should be allowed

func test_reset_clears_cooldown() -> void:
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0))
	weapon.reset()
	assert_true(weapon.try_fire(0.0))  # Should be allowed after reset

func test_reset_on_new_weapon() -> void:
	var weapon := Weapon.new()
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))  # 0.125 seconds is less than 0.25 (1/4)

func test_reset_with_past_time() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(1.0)
	weapon.reset()
	assert_true(weapon.try_fire(1.0))  # Should work even with same time
	assert_false(weapon.try_fire(1.125))  # 0.125 seconds is less than 0.25

func test_reset_with_earlier_time() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(10.0)
	weapon.reset()
	assert_true(weapon.try_fire(3.0))  # Should work even with earlier time

func test_fire_rate_change() -> void:
	var weapon := Weapon.new()
	weapon.fire_rate = 2.0  # 1 shot every 0.5 seconds
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.4))  # Too early - only 0.4 seconds passed
	assert_true(weapon.try_fire(0.5))  # Exactly 0.5 seconds - should be allowed

func test_fire_rate_stays_same_after_reset() -> void:
	var weapon := Weapon.new()
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)  # fire_rate should not change after reset

func test_multiple_resets() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(0.0)
	weapon.reset()
	weapon.reset()  # Second reset should be harmless
	assert_true(weapon.try_fire(0.0))