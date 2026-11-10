extends GutTest

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_first_shot_fires() -> void:
	assert_true(weapon.try_fire(0.0))


func test_immediate_second_shot_is_blocked() -> void:
	weapon.try_fire(0.0)
	assert_false(weapon.try_fire(0.0))


func test_fire_rate_4_default() -> void:
	# With default fire_rate = 4.0, should allow shots every 0.25 seconds
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(0.2))  # Too soon (0.2 < 0.25)
	assert_true(weapon.try_fire(0.25))  # Exactly right time


func test_fire_rate_2() -> void:
	weapon.fire_rate = 2.0
	# With fire_rate = 2.0, should allow shots every 0.5 seconds
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(0.4))  # Too soon (0.4 < 0.5)
	assert_true(weapon.try_fire(0.5))  # Exactly right time


func test_fire_rate_0_5() -> void:
	weapon.fire_rate = 0.5
	# With fire_rate = 0.5, should allow shots every 2.0 seconds
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(1.5))  # Too soon (1.5 < 2.0)
	assert_true(weapon.try_fire(2.0))  # Exactly right time