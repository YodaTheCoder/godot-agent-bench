extends GutTest

func test_first_shot_at_zero() -> void:
	var w := Weapon.new()
	add_child_autofree(w)
	assert_true(w.try_fire(0.0))

func test_fire_rate_is_shots_per_second() -> void:
	var w := Weapon.new()
	add_child_autofree(w)
	# With fire_rate = 4.0, minimum time between shots is 0.25 seconds
	assert_true(w.try_fire(0.0))
	assert_false(w.try_fire(0.2))  # 0.2 < 0.25, should be blocked
	assert_true(w.try_fire(0.25))  # exactly 0.25, should be allowed

func test_reset_clears_cooldown() -> void:
	var w := Weapon.new()
	add_child_autofree(w)
	assert_true(w.try_fire(0.0))
	w.reset()
	assert_true(w.try_fire(0.0))  # reset allows shot at any time

func test_reset_on_never_fired_weapon() -> void:
	var w := Weapon.new()
	add_child_autofree(w)
	w.reset()
	assert_true(w.try_fire(0.0))
	assert_false(w.try_fire(0.125))  # 0.125 < 0.25

func test_blocked_shot_does_not_restart_cooldown() -> void:
	var w := Weapon.new()
	add_child_autofree(w)
	assert_true(w.try_fire(1.0))
	w.reset()
	assert_true(w.try_fire(1.0))  # after reset, any time is fine
	assert_false(w.try_fire(1.125))  # still in cooldown (0.125 < 0.25)
	assert_true(w.try_fire(1.25))  # exactly at cooldown boundary, allowed

func test_reset_allows_earlier_time() -> void:
	var w := Weapon.new()
	add_child_autofree(w)
	assert_true(w.try_fire(10.0))
	w.reset()
	assert_true(w.try_fire(3.0))  # earlier time than last shot, allowed

func test_fire_rate_preserved_after_reset() -> void:
	var w := Weapon.new()
	add_child_autofree(w)
	w.fire_rate = 2.0
	w.reset()
	assert_eq(w.fire_rate, 2.0)