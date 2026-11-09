extends GutTest

var weapon: Weapon


func before_each() -> void:
	weapon = Weapon.new()
	add_child_autofree(weapon)


func test_first_shot_fires() -> void:
	assert_true(weapon.try_fire(0.0))


func test_immediate_second_shot_is_blocked() -> void:
	weapon.try_fire(0.0)
	assert_false(weapon.try_fire(0.0))


func test_fire_rate_shots_per_second() -> void:
	# Test default fire_rate = 4.0 (one shot every 0.25 seconds)
	weapon.fire_rate = 4.0
	assert_true(weapon.try_fire(0.0)) # First shot always succeeds
	assert_false(weapon.try_fire(0.2)) # Should not be able to shoot again so soon
	assert_true(weapon.try_fire(0.25)) # Should be able to shoot after 0.25 seconds (1/4 = 0.25)
	
	# Test fire_rate = 2.0 (one shot every 0.5 seconds)
	weapon.fire_rate = 2.0
	assert_true(weapon.try_fire(0.0)) # First shot always succeeds
	assert_false(weapon.try_fire(0.4)) # Should not be able to shoot again so soon
	assert_true(weapon.try_fire(0.5)) # Should be able to shoot after 0.5 seconds (1/2 = 0.5)
	
	# Test fire_rate = 0.5 (one shot every 2.0 seconds)
	weapon.fire_rate = 0.5
	assert_true(weapon.try_fire(0.0)) # First shot always succeeds
	assert_false(weapon.try_fire(1.5)) # Should not be able to shoot again so soon
	assert_true(weapon.try_fire(2.0)) # Should be able to shoot after 2.0 seconds (1/0.5 = 2.0)
