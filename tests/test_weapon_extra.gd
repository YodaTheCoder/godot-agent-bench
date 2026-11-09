extends GutTest

func test_default_fire_rate_4_shots_per_second() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.2))
	assert_true(weapon.try_fire(0.25))

func test_reset_clears_cooldown() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.try_fire(0.0)
	weapon.reset()
	assert_true(weapon.try_fire(0.0))

func test_reset_on_never_fired() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.reset()
	assert_true(weapon.try_fire(0.0))

func test_reset_allow_earlier_time() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.try_fire(10.0)
	weapon.reset()
	assert_true(weapon.try_fire(3.0))

func test_fire_rate_preserves_after_reset() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)

func test_custom_fire_rate() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.4))
	assert_true(weapon.try_fire(0.5))

func test_blocked_attempts_do_not_reset_cooldown() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.1))
	assert_false(weapon.try_fire(0.25))
	assert_true(weapon.try_fire(0.5))