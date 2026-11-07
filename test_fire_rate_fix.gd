extends GutTest

func test_default_fire_rate() -> void:
	var weapon = Weapon.new()
	
	# With default fire_rate = 4.0, should allow shot every 0.25 seconds (1/4)
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(0.2))  # Not enough time passed
	assert_true(weapon.try_fire(0.25))  # Exactly 0.25 seconds - should be allowed


func test_fire_rate_2() -> void:
	var weapon = Weapon.new()
	weapon.fire_rate = 2.0
	
	# With fire_rate = 2.0, should allow shot every 0.5 seconds (1/2)
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(0.4))  # Not enough time passed
	assert_true(weapon.try_fire(0.5))  # Exactly 0.5 seconds - should be allowed


func test_fire_rate_0_5() -> void:
	var weapon = Weapon.new()
	weapon.fire_rate = 0.5
	
	# With fire_rate = 0.5, should allow shot every 2.0 seconds (1/0.5)
	assert_true(weapon.try_fire(0.0))  # First shot always allowed
	assert_false(weapon.try_fire(1.5))  # Not enough time passed
	assert_true(weapon.try_fire(2.0))  # Exactly 2.0 seconds - should be allowed