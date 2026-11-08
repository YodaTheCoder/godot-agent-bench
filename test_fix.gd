extends Node

func test_fire_rate_fix():
	# Create a weapon instance
	var weapon = Weapon.new()
	
	print("Testing default fire_rate (4.0):")
	# First shot should always be allowed
	assert(weapon.try_fire(0.0) == true)
	print("  try_fire(0.0) → true ✓")
	
	# Second shot at 0.2s should be blocked (0.2 < 0.25, min_interval = 1/4 = 0.25)
	assert(weapon.try_fire(0.2) == false)
	print("  try_fire(0.2) → false ✓")
	
	# Third shot at 0.25s should be allowed (0.25 == 0.25, exactly min_interval)
	assert(weapon.try_fire(0.25) == true)
	print("  try_fire(0.25) → true ✓")
	
	print("Testing fire_rate = 2.0:")
	weapon.fire_rate = 2.0
	assert(weapon.try_fire(0.0) == true)
	print("  try_fire(0.0) → true ✓")
	
	# Shot at 0.4s should be blocked (0.4 < 0.5, min_interval = 1/2 = 0.5)
	assert(weapon.try_fire(0.4) == false)
	print("  try_fire(0.4) → false ✓")
	
	# Shot at 0.5s should be allowed (0.5 == 0.5, exactly min_interval)
	assert(weapon.try_fire(0.5) == true)
	print("  try_fire(0.5) → true ✓")
	
	print("Testing fire_rate = 0.5:")
	weapon.fire_rate = 0.5
	assert(weapon.try_fire(0.0) == true)
	print("  try_fire(0.0) → true ✓")
	
	# Shot at 1.5s should be blocked (1.5 < 2.0, min_interval = 1/0.5 = 2.0)
	assert(weapon.try_fire(1.5) == false)
	print("  try_fire(1.5) → false ✓")
	
	# Shot at 2.0s should be allowed (2.0 == 2.0, exactly min_interval)
	assert(weapon.try_fire(2.0) == true)
	print("  try_fire(2.0) → true ✓")
	
	print("All tests passed! ✓")

func _ready():
	test_fire_rate_fix()