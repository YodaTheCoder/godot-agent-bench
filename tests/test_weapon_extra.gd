extends GutTest
## Weapon cooldown and reset() tests. Uses only the public API: fire_rate,
## try_fire(now) and reset(). Time values are exact in binary floating point.

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_first_shot_always_fires() -> void:
	assert_true(weapon.try_fire(0.0))


func test_default_rate_is_four_shots_per_second() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125), "0.125 s after a shot is too soon")
	assert_false(weapon.try_fire(0.2))
	assert_true(weapon.try_fire(0.25), "exactly 1 / fire_rate later is allowed")


func test_boundary_is_inclusive_at_custom_rate() -> void:
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(1.0))
	assert_false(weapon.try_fire(1.25))
	assert_true(weapon.try_fire(1.5))


func test_slow_rate_waits_whole_period() -> void:
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(1.5))
	assert_true(weapon.try_fire(2.0))


func test_blocked_attempts_do_not_restart_cooldown() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))
	assert_false(weapon.try_fire(0.1875))
	assert_true(weapon.try_fire(0.25))


func test_cooldown_counts_from_last_successful_shot() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_true(weapon.try_fire(0.5))
	assert_false(weapon.try_fire(0.625))
	assert_true(weapon.try_fire(0.75))


func test_reset_allows_immediate_shot() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.0))
	weapon.reset()
	assert_true(weapon.try_fire(0.0), "reset clears the cooldown")


func test_cooldown_applies_again_after_reset() -> void:
	assert_true(weapon.try_fire(1.0))
	weapon.reset()
	assert_true(weapon.try_fire(1.0))
	assert_false(weapon.try_fire(1.125))
	assert_true(weapon.try_fire(1.25))


func test_reset_keeps_fire_rate() -> void:
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)
