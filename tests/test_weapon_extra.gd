extends GutTest


func test_default_fire_rate_basic() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)

	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.2))
	assert_true(weapon.try_fire(0.25))


func test_reset_clears_cooldown() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)

	assert_true(weapon.try_fire(0.0))
	weapon.reset()
	assert_true(weapon.try_fire(0.0))


func test_reset_on_never_fired_weapon() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)

	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))


func test_reset_after_shot_with_later_time() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)

	assert_true(weapon.try_fire(10.0))
	weapon.reset()
	assert_true(weapon.try_fire(3.0))


func test_fire_rate_unchanged_after_reset() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.fire_rate = 2.0

	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)


func test_fire_rate_2_shots_per_second() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.fire_rate = 2.0

	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.3))
	assert_true(weapon.try_fire(0.5))
	assert_false(weapon.try_fire(0.7))
	assert_true(weapon.try_fire(1.0))