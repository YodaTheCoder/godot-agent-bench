extends GutTest

func test_default_fire_rate() -> void:
	var weapon = Weapon.new()
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(0.2))  # Too soon (0.2 < 1.0/4.0 = 0.25)
	assert_true(weapon.try_fire(0.25))  # Exactly right


func test_reset_clears_cooldown() -> void:
	var weapon = Weapon.new()
	assert_true(weapon.try_fire(0.0))
	weapon.reset()
	assert_true(weapon.try_fire(0.0))  # Should be allowed after reset


func test_reset_on_new_weapon() -> void:
	var weapon = Weapon.new()
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))  # Too soon (0.125 < 1.0/4.0 = 0.25)


func test_reset_with_past_time() -> void:
	var weapon = Weapon.new()
	weapon.try_fire(1.0)
	weapon.reset()
	assert_true(weapon.try_fire(1.0))  # Should be allowed even with past time
	assert_false(weapon.try_fire(1.125))  # Too soon
	assert_true(weapon.try_fire(1.25))  # Exactly right


func test_reset_with_earlier_time() -> void:
	var weapon = Weapon.new()
	weapon.try_fire(10.0)
	weapon.reset()
	assert_true(weapon.try_fire(3.0))  # Should be allowed even with earlier time


func test_fire_rate_change() -> void:
	var weapon = Weapon.new()
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)  # fire_rate should remain unchanged after reset


func test_cooldown_boundary_conditions() -> void:
	var weapon = Weapon.new()
	# Test boundary conditions for different fire rates
	weapon.fire_rate = 1.0  # 1 shot per second, 1.0 seconds between shots
	assert_true(weapon.try_fire(0.0))  # First shot
	assert_false(weapon.try_fire(0.9))  # Too soon
	assert_true(weapon.try_fire(1.0))  # Exactly right
	assert_false(weapon.try_fire(1.9))  # Too soon
	assert_true(weapon.try_fire(2.0))  # Exactly right


func test_multiple_reset_scenarios() -> void:
	var weapon = Weapon.new()
	# Multiple resets
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	
	weapon.reset()
	assert_true(weapon.try_fire(5.0))  # Even with a large time difference
	
	weapon.try_fire(10.0)
	weapon.reset()
	assert_true(weapon.try_fire(15.0))  # Should work after reset