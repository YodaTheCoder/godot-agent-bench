class_name Weapon extends Node
## Shots per second.
@export var fire_rate := 4.0

var _last_shot_time := -INF


func try_fire(now: float) -> bool:
	if now - _last_shot_time < 1.0 / fire_rate:
		return false
	_last_shot_time = now
	return true

# Test the fix
func test_fix():
	print("Testing weapon cooldown fix...")

	# Test with default fire_rate = 4.0
	var weapon = Weapon.new()

	# First shot should always be allowed
	assert(weapon.try_fire(0.0) == true)
	print("First shot at 0.0: OK")

	# Second shot too early should be blocked
	assert(weapon.try_fire(0.2) == false)
	print("Shot at 0.2 (too early): OK")

	# Shot at exactly 0.25 (1/4 of a second) should be allowed with fire_rate = 4.0
	assert(weapon.try_fire(0.25) == true)
	print("Shot at 0.25: OK")

	# Test with fire_rate = 2.0 (one shot every 0.5 seconds)
	weapon.fire_rate = 2.0
	assert(weapon.try_fire(0.0) == true)
	print("First shot with fire_rate=2.0 at 0.0: OK")

	assert(weapon.try_fire(0.4) == false)
	print("Shot at 0.4 (too early with fire_rate=2.0): OK")

	assert(weapon.try_fire(0.5) == true)
	print("Shot at 0.5 (exactly 0.5 seconds) with fire_rate=2.0: OK")

	# Test with fire_rate = 0.5 (one shot every 2 seconds)
	weapon.fire_rate = 0.5
	assert(weapon.try_fire(0.0) == true)
	print("First shot with fire_rate=0.5 at 0.0: OK")

	assert(weapon.try_fire(1.5) == false)
	print("Shot at 1.5 (too early with fire_rate=0.5): OK")

	assert(weapon.try_fire(2.0) == true)
	print("Shot at 2.0 (exactly 2 seconds) with fire_rate=0.5: OK")

	print("All tests passed!")

test_fix()
