extends GutTest

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_weapon_has_reset() -> void:
	assert_true(weapon.has_method("reset"))


func test_reset_after_shot_allows_immediate_shot() -> void:
	assert_true(weapon.try_fire(0.0))
	weapon.reset()
	assert_true(weapon.try_fire(0.0))


func test_reset_on_new_weapon_is_harmless() -> void:
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))


func test_cooldown_restarts_from_shot_after_reset() -> void:
	assert_true(weapon.try_fire(1.0))
	weapon.reset()
	assert_true(weapon.try_fire(1.0))
	assert_false(weapon.try_fire(1.125))
	assert_true(weapon.try_fire(1.25))


func test_reset_allows_earlier_time() -> void:
	assert_true(weapon.try_fire(10.0))
	weapon.reset()
	assert_true(weapon.try_fire(3.0), "time may restart after a reset")


func test_reset_keeps_fire_rate() -> void:
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)


func test_fire_rate_is_shots_per_second() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.2))
	assert_true(weapon.try_fire(0.25))
