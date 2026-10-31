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


func test_default_rate_fires_four_times_per_second() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.2))
	assert_true(weapon.try_fire(0.25))


func test_blocked_attempt_does_not_restart_cooldown() -> void:
	weapon.try_fire(0.0)
	weapon.try_fire(0.2)
	assert_true(weapon.try_fire(0.25))
	assert_false(weapon.try_fire(0.45))
	assert_true(weapon.try_fire(0.5))


func test_exact_interval_with_float_rounding_is_allowed() -> void:
	weapon.try_fire(0.1)
	assert_true(weapon.try_fire(0.35))


func test_cooldown_follows_changed_fire_rate() -> void:
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.4))
	assert_true(weapon.try_fire(0.5))


func test_slow_fire_rate() -> void:
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(1.5))
	assert_true(weapon.try_fire(2.0))
