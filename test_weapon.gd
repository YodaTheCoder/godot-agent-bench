extends Node

func _ready():
	test_fire_rate_4()
	test_fire_rate_2()
	test_fire_rate_05()

func test_fire_rate_4():
	print("Testing fire_rate = 4.0")
	var weapon = Weapon.new()
	weapon.fire_rate = 4.0
	
	# try_fire(0.0) → true
	assert(weapon.try_fire(0.0) == true)
	print("  try_fire(0.0) → true ✓")
	
	# then try_fire(0.2) → false (0.2 - 0.0 = 0.2 < 1/4 = 0.25)
	assert(weapon.try_fire(0.2) == false)
	print("  try_fire(0.2) → false ✓")
	
	# then try_fire(0.25) → true (0.25 - 0.0 = 0.25 >= 1/4 = 0.25)
	assert(weapon.try_fire(0.25) == true)
	print("  try_fire(0.25) → true ✓")
	
	print("fire_rate = 4.0 tests passed!\n")

func test_fire_rate_2():
	print("Testing fire_rate = 2.0")
	var weapon = Weapon.new()
	weapon.fire_rate = 2.0
	
	# try_fire(0.0) → true
	assert(weapon.try_fire(0.0) == true)
	print("  try_fire(0.0) → true ✓")
	
	# try_fire(0.4) → false (0.4 - 0.0 = 0.4 < 1/2 = 0.5)
	assert(weapon.try_fire(0.4) == false)
	print("  try_fire(0.4) → false ✓")
	
	# try_fire(0.5) → true (0.5 - 0.0 = 0.5 >= 1/2 = 0.5)
	assert(weapon.try_fire(0.5) == true)
	print("  try_fire(0.5) → true ✓")
	
	print("fire_rate = 2.0 tests passed!\n")

func test_fire_rate_05():
	print("Testing fire_rate = 0.5")
	var weapon = Weapon.new()
	weapon.fire_rate = 0.5
	
	# try_fire(0.0) → true
	assert(weapon.try_fire(0.0) == true)
	print("  try_fire(0.0) → true ✓")
	
	# try_fire(1.5) → false (1.5 - 0.0 = 1.5 < 1/0.5 = 2.0)
	assert(weapon.try_fire(1.5) == false)
	print("  try_fire(1.5) → false ✓")
	
	# try_fire(2.0) → true (2.0 - 0.0 = 2.0 >= 1/0.5 = 2.0)
	assert(weapon.try_fire(2.0) == true)
	print("  try_fire(2.0) → true ✓")
	
	print("fire_rate = 0.5 tests passed!\n")