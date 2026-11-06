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


func test_fire_rate_4_default_behavior() -> void:
	# With default fire_rate = 4.0:
	# - try_fire(0.0) → true
	# - then try_fire(0.2) → false  
	# - then try_fire(0.25) → true
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.2))
	assert_true(weapon.try_fire(0.25))


func test_fire_rate_2_behavior() -> void:
	# With fire_rate = 2.0:
	# - try_fire(0.0) → true
	# - then try_fire(0.4) → false
	# - then try_fire(0.5) → true
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.4))
	assert_true(weapon.try_fire(0.5))


func test_fire_rate_0_5_behavior() -> void:
	# With fire_rate = 0.5:
	# - try_fire(0.0) → true
	# - then try_fire(1.5) → false
	# - then try_fire(2.0) → true
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(1.5))
	assert_true(weapon.try_fire(2.0))
