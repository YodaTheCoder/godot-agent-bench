extends GutTest

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_default_fire_rate() -> void:
	# With default fire_rate = 4.0, should allow shot every 0.25 seconds (1/4)
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(0.2))  # Not enough time passed (0.2 < 0.25)
	assert_true(weapon.try_fire(0.25))  # Exactly right time


func test_fire_rate_2() -> void:
	# With fire_rate = 2.0, should allow shot every 0.5 seconds (1/2)
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(0.4))  # Not enough time passed (0.4 < 0.5)
	assert_true(weapon.try_fire(0.5))  # Exactly right time


func test_fire_rate_0_5() -> void:
	# With fire_rate = 0.5, should allow shot every 2.0 seconds (1/0.5)
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(1.5))  # Not enough time passed (1.5 < 2.0)
	assert_true(weapon.try_fire(2.0))  # Exactly right time


func test_shot_counting() -> void:
	# Test that failed attempts don't count as shots
	weapon.fire_rate = 4.0
	assert_true(weapon.try_fire(0.0))  # First shot
	assert_false(weapon.try_fire(0.1))  # Too soon - doesn't count as shot
	assert_false(weapon.try_fire(0.2))  # Still too soon - doesn't count as shot
	assert_true(weapon.try_fire(0.3))  # Enough time passed now


func test_cooldown_follows_fire_rate() -> void:
	# Test that changing fire_rate changes cooldown
	weapon.fire_rate = 4.0
	assert_true(weapon.try_fire(0.0))
	
	# Change fire_rate to 2.0 (should be twice as fast)
	weapon.fire_rate = 2.0
	assert_false(weapon.try_fire(0.1))  # Not enough time with new rate (0.1 < 0.5)
	assert_true(weapon.try_fire(0.6))  # Enough time with new rate