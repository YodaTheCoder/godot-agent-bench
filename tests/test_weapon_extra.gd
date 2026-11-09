extends GutTest

func test_default_fire_rate_accepts_first_shot() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	assert_true(weapon.try_fire(0.0))


func test_default_fire_rate_blocks_before_min_interval() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.try_fire(0.0)
	assert_false(weapon.try_fire(0.2))


func test_default_fire_rate_accepts_at_min_interval() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.try_fire(0.0)
	assert_true(weapon.try_fire(0.25))


func test_reset_allows_immediate_shot() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.try_fire(0.0)
	weapon.reset()
	assert_true(weapon.try_fire(0.0))


func test_reset_allows_shot_at_earlier_time() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.try_fire(10.0)
	weapon.reset()
	assert_true(weapon.try_fire(3.0))


func test_reset_does_not_change_fire_rate() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)


func test_reset_on_never_fired_weapon() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.reset()
	assert_true(weapon.try_fire(0.0))


func test_reset_clears_cooldown_after_shot() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.try_fire(1.0)
	weapon.reset()
	assert_true(weapon.try_fire(1.0))


func test_reset_normal_cooldown_after_shot() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.try_fire(1.0)
	weapon.reset()
	assert_true(weapon.try_fire(1.0))
	assert_false(weapon.try_fire(1.125))
	assert_true(weapon.try_fire(1.25))


func test_blocked_shot_does_not_restart_cooldown() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.fire_rate = 2.0
	weapon.try_fire(0.0)
	assert_false(weapon.try_fire(0.3))
	assert_true(weapon.try_fire(0.5))


func test_custom_fire_rate_2_dpps() -> void:
	var weapon := Weapon.new()
	add_child_autofree(weapon)
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0))
	assert_false(weapon.try_fire(0.25))
	assert_true(weapon.try_fire(0.5))