extends GutTest

var weapon: Weapon

func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)

func test_requirements_default_fire_rate() -> void:
	# With default fire_rate = 4.0
	# 1.0 / 4.0 = 0.25
	assert_true(weapon.try_fire(0.0), "First shot at 0.0 should be allowed")
	assert_false(weapon.try_fire(0.2), "Shot at 0.2 should be blocked (needs 0.25)")
	assert_true(weapon.try_fire(0.25), "Shot at 0.25 should be allowed")

func test_requirements_fire_rate_2() -> void:
	# With fire_rate = 2.0
	# 1.0 / 2.0 = 0.5
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0), "First shot at 0.0 should be allowed")
	assert_false(weapon.try_fire(0.4), "Shot at 0.4 should be blocked (needs 0.5)")
	assert_true(weapon.try_fire(0.5), "Shot at 0.5 should be allowed")

func test_requirements_fire_rate_05() -> void:
	# With fire_rate = 0.5
	# 1.0 / 0.5 = 2.0
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0), "First shot at 0.0 should be allowed")
	assert_false(weapon.try_fire(1.5), "Shot at 1.5 should be blocked (needs 2.0)")
	assert_true(weapon.try_fire(2.0), "Shot at 2.0 should be allowed")

func test_blocked_attempt_does_not_reset_cooldown() -> void:
	weapon.fire_rate = 1.0
	# 1.0 / 1.0 = 1.0
	assert_true(weapon.try_fire(0.0), "First shot at 0.0 should be allowed")
	assert_false(weapon.try_fire(0.5), "Shot at 0.5 should be blocked")
	# If it reset, 0.5 + 1.0 = 1.5 would be the next allowed time.
	# But since it's not reset, 0.0 + 1.0 = 1.0 should be the next allowed time.
	assert_true(weapon.try_fire(1.0), "Shot at 1.0 should be allowed because blocked attempt didn't reset cooldown")
