extends GutTest

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_first_shot_fires() -> void:
	assert_true(weapon.try_fire(0.0))


func test_default_fire_rate_allows_shots_at_correct_interval() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.2))
	assert_true(weapon.try_fire(0.25))


func test_blocked_shot_does_not_restart_cooldown() -> void:
	weapon.try_fire(0.0)
	assert_false(weapon.try_fire(0.1))
	assert_false(weapon.try_fire(0.15))
	assert_true(weapon.try_fire(0.25))


func test_reset_clears_cooldown() -> void:
	weapon.try_fire(1.0)
	weapon.reset()
	assert_true(weapon.try_fire(1.0))


func test_reset_allows_earlier_time() -> void:
	weapon.try_fire(10.0)
	weapon.reset()
	assert_true(weapon.try_fire(3.0))


func test_reset_does_not_change_fire_rate() -> void:
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)


func test_reset_on_new_weapon_is_harmless() -> void:
	weapon.reset()
	assert_true(weapon.try_fire(0.0))


func test_reset_then_normal_cooldown() -> void:
	weapon.try_fire(1.0)
	weapon.reset()
	assert_true(weapon.try_fire(1.0))
	assert_false(weapon.try_fire(1.125))
	assert_true(weapon.try_fire(1.25))


func test_fire_rate_as_shots_per_second() -> void:
	weapon.fire_rate = 2.0
	weapon.try_fire(0.0)
	assert_true(weapon.try_fire(0.5))
	assert_false(weapon.try_fire(0.75))
	assert_true(weapon.try_fire(1.0))


func test_exactly_at_cooldown_boundary_is_allowed() -> void:
	weapon.fire_rate = 4.0
	weapon.try_fire(0.0)
	assert_true(weapon.try_fire(0.25))