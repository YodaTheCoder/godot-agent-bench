extends GutTest

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_default_fire_rate_is_shots_per_second() -> void:
	assert_true(weapon.try_fire(0.0), "first shot")
	assert_false(weapon.try_fire(0.2), "0.2 s is inside the 0.25 s cooldown")
	assert_true(weapon.try_fire(0.25), "0.25 s is exactly 1 / 4.0")


func test_four_shots_in_one_second_at_default_rate() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_true(weapon.try_fire(0.25))
	assert_true(weapon.try_fire(0.5))
	assert_true(weapon.try_fire(0.75))
	assert_true(weapon.try_fire(1.0))


func test_shot_exactly_at_cooldown_boundary_is_allowed() -> void:
	assert_true(weapon.try_fire(1.0))
	assert_true(weapon.try_fire(1.25), "exactly 1 / fire_rate later")


func test_shot_just_before_boundary_is_blocked() -> void:
	assert_true(weapon.try_fire(1.0))
	assert_false(weapon.try_fire(1.1875))


func test_first_shot_always_allowed() -> void:
	assert_true(weapon.try_fire(0.0))


func test_first_shot_allowed_at_negative_time() -> void:
	assert_true(weapon.try_fire(-5.0))


func test_blocked_attempt_does_not_restart_cooldown() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))
	assert_false(weapon.try_fire(0.1875))
	assert_true(weapon.try_fire(0.25), "cooldown measured from last successful shot")


func test_custom_fire_rate_two() -> void:
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.25))
	assert_false(weapon.try_fire(0.375))
	assert_true(weapon.try_fire(0.5), "exactly 1 / 2.0 later")
	assert_false(weapon.try_fire(0.75))
	assert_true(weapon.try_fire(1.0))


func test_custom_fire_rate_eight() -> void:
	weapon.fire_rate = 8.0
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.0625))
	assert_true(weapon.try_fire(0.125))


func test_slow_fire_rate_half() -> void:
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(1.0))
	assert_false(weapon.try_fire(1.5))
	assert_true(weapon.try_fire(2.0), "exactly 1 / 0.5 later")


func test_fire_rate_change_applies_to_cooldown() -> void:
	assert_true(weapon.try_fire(0.0))
	weapon.fire_rate = 2.0
	assert_false(weapon.try_fire(0.25))
	assert_true(weapon.try_fire(0.5))


func test_reset_allows_immediate_shot_at_same_time() -> void:
	assert_true(weapon.try_fire(0.0))
	weapon.reset()
	assert_true(weapon.try_fire(0.0))


func test_reset_allows_shot_inside_cooldown() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))
	weapon.reset()
	assert_true(weapon.try_fire(0.125))


func test_reset_on_new_weapon_is_harmless() -> void:
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))


func test_cooldown_works_normally_after_reset() -> void:
	assert_true(weapon.try_fire(1.0))
	weapon.reset()
	assert_true(weapon.try_fire(1.0))
	assert_false(weapon.try_fire(1.125))
	assert_true(weapon.try_fire(1.25))


func test_reset_allows_shot_earlier_than_last_shot() -> void:
	assert_true(weapon.try_fire(10.0))
	weapon.reset()
	assert_true(weapon.try_fire(3.0))


func test_reset_then_earlier_time_cooldown_works() -> void:
	assert_true(weapon.try_fire(10.0))
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))
	assert_true(weapon.try_fire(0.25))


func test_reset_with_slow_fire_rate() -> void:
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(1.0))
	weapon.reset()
	assert_true(weapon.try_fire(1.0))


func test_reset_does_not_change_fire_rate() -> void:
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)


func test_reset_does_not_change_default_fire_rate() -> void:
	weapon.reset()
	assert_eq(weapon.fire_rate, 4.0)


func test_repeated_reset_is_harmless() -> void:
	weapon.reset()
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	weapon.reset()
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
