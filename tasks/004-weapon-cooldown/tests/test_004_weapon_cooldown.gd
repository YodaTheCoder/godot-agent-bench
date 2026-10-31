extends GutTest

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_default_rate_fires_four_times_per_second() -> void:
	assert_true(weapon.try_fire(0.0), "first shot")
	assert_false(weapon.try_fire(0.2), "0.2 s after: still cooling down")
	assert_true(weapon.try_fire(0.25), "0.25 s after: cooldown over")


func test_blocked_attempt_does_not_restart_cooldown() -> void:
	weapon.try_fire(0.0)
	weapon.try_fire(0.1)
	weapon.try_fire(0.2)
	assert_true(weapon.try_fire(0.25))


func test_cooldown_follows_custom_fire_rate() -> void:
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.4))
	assert_true(weapon.try_fire(0.5))


func test_slow_fire_rate() -> void:
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(1.5))
	assert_true(weapon.try_fire(2.0))


func test_cooldown_restarts_from_last_successful_shot() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_true(weapon.try_fire(0.3))
	assert_false(weapon.try_fire(0.5))
	assert_true(weapon.try_fire(0.6))
