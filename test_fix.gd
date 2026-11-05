extends GutTest

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_default_fire_rate() -> void:
	# With default fire_rate = 4.0, should allow shots every 0.25 seconds (1/4)
	assert_true(weapon.try_fire(0.0))   # First shot always allowed
	assert_false(weapon.try_fire(0.2))  # Not enough time (0.2 < 0.25)
	assert_true(weapon.try_fire(0.25))  # Exactly 0.25 seconds - should be allowed


func test_fire_rate_2() -> void:
	# With fire_rate = 2.0, should allow shots every 0.5 seconds (1/2)
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))   # First shot always allowed
	assert_false(weapon.try_fire(0.4))  # Not enough time (0.4 < 0.5)
	assert_true(weapon.try_fire(0.5))   # Exactly 0.5 seconds - should be allowed


func test_fire_rate_0_5() -> void:
	# With fire_rate = 0.5, should allow shots every 2.0 seconds (1/0.5)
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0))   # First shot always allowed
	assert_false(weapon.try_fire(1.5))  # Not enough time (1.5 < 2.0)
	assert_true(weapon.try_fire(2.0))   # Exactly 2.0 seconds - should be allowed