extends GutTest

var weapon: Weapon

func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)

func test_default_fire_rate() -> void:
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.2))
	assert_true(weapon.try_fire(0.25))

func test_reset_allows_shot_at_same_time() -> void:
	weapon.try_fire(0.0)
	weapon.reset()
	assert_true(weapon.try_fire(0.0))

func test_reset_on_new_weapon() -> void:
	weapon.reset()
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.125))

func test_reset_allows_earlier_time() -> void:
	weapon.try_fire(10.0)
	weapon.reset()
	assert_true(weapon.try_fire(3.0))

func test_fire_rate_remains_after_reset() -> void:
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)

func test_fire_rate_is_shots_per_second() -> void:
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.25))
	assert_true(weapon.try_fire(0.5))
	assert_false(weapon.try_fire(0.75))
	assert_true(weapon.try_fire(1.0))

func test_shot_allowed_at_exact_cooldown_boundary() -> void:
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))
	assert_true(weapon.try_fire(0.5))