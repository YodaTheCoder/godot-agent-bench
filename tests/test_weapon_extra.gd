extends GutTest

func test_default_fire_rate() -> void:
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0))  # First shot should always succeed
	assert_false(weapon.try_fire(0.2))  # Should be blocked (0.2 < 1.0/4.0 = 0.25)
	assert_true(weapon.try_fire(0.25))  # Should succeed (exactly 0.25 seconds)


func test_reset_clears_cooldown() -> void:
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0))
	weapon.reset()
	assert_true(weapon.try_fire(0.0))  # Should succeed after reset


func test_reset_on_new_weapon() -> void:
	var weapon := Weapon.new()
	weapon.reset()
	assert_true(weapon.try_fire(0.0))  # Should succeed even after reset on a new weapon
	assert_false(weapon.try_fire(0.125))  # Should be blocked (0.125 < 0.25)


func test_reset_with_past_time() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(1.0)
	weapon.reset()
	assert_true(weapon.try_fire(1.0))  # Should succeed even with past time
	assert_false(weapon.try_fire(1.125))  # Should be blocked
	assert_true(weapon.try_fire(1.25))  # Should succeed after cooldown


func test_reset_with_earlier_time() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(10.0)
	weapon.reset()
	assert_true(weapon.try_fire(3.0))  # Should succeed even with earlier time


func test_fire_rate_change() -> void:
	var weapon := Weapon.new()
	weapon.fire_rate = 2.0  # One shot every 0.5 seconds
	assert_true(weapon.try_fire(0.0))
	weapon.reset()
	assert_true(weapon.fire_rate == 2.0)  # fire_rate should be unchanged after reset


func test_multiple_reset_scenarios() -> void:
	var weapon := Weapon.new()
	# First shot
	assert_true(weapon.try_fire(0.0))
	# Second shot blocked
	assert_false(weapon.try_fire(0.2))
	# Reset cooldown
	weapon.reset()
	# Should be able to fire immediately after reset
	assert_true(weapon.try_fire(0.1))
	# Next shot still blocked
	assert_false(weapon.try_fire(0.2))
	# Third shot after cooldown
	assert_true(weapon.try_fire(0.5))