extends GutTest

func test_default_fire_rate() -> void:
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0))  # First shot always OK
	assert_false(weapon.try_fire(0.2))  # Too early (0.2 < 1.0/4.0 = 0.25)
	assert_true(weapon.try_fire(0.25))  # Exactly right


func test_reset_clears_cooldown() -> void:
	var weapon := Weapon.new()
	assert_true(weapon.try_fire(0.0))
	weapon.reset()
	assert_true(weapon.try_fire(0.0))  # Should work after reset


func test_reset_on_new_weapon() -> void:
	var weapon := Weapon.new()
	weapon.reset()
	assert_true(weapon.try_fire(0.0))  # Should work even on new weapon
	assert_false(weapon.try_fire(0.125))  # Too early (0.125 < 1.0/4.0 = 0.25)


func test_reset_with_past_time() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(1.0)
	weapon.reset()
	assert_true(weapon.try_fire(1.0))  # Should work even with past time
	assert_false(weapon.try_fire(1.125))  # Too early
	assert_true(weapon.try_fire(1.25))  # Exactly right


func test_reset_with_earlier_time() -> void:
	var weapon := Weapon.new()
	weapon.try_fire(10.0)
	weapon.reset()
	assert_true(weapon.try_fire(3.0))  # Should work even with earlier time


func test_fire_rate_change() -> void:
	var weapon := Weapon.new()
	weapon.fire_rate = 2.0
	weapon.reset()
	assert_eq(weapon.fire_rate, 2.0)  # Fire rate unchanged