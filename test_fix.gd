extends Node

func _ready():
	var weapon = Weapon.new()
	
	# Test default fire_rate = 4.0 (should be 1 shot every 0.25 seconds)
	print("Testing fire_rate = 4.0")
	assert(weapon.try_fire(0.0) == true, "First shot should succeed")
	assert(weapon.try_fire(0.2) == false, "Shot at 0.2s should be blocked (0.2 < 0.25)")
	assert(weapon.try_fire(0.25) == true, "Shot at 0.25s should succeed")
	
	# Test fire_rate = 2.0 (should be 1 shot every 0.5 seconds)
	weapon.fire_rate = 2.0
	print("Testing fire_rate = 2.0")
	assert(weapon.try_fire(0.0) == true, "First shot should succeed")
	assert(weapon.try_fire(0.4) == false, "Shot at 0.4s should be blocked (0.4 < 0.5)")
	assert(weapon.try_fire(0.5) == true, "Shot at 0.5s should succeed")
	
	# Test fire_rate = 0.5 (should be 1 shot every 2 seconds)
	weapon.fire_rate = 0.5
	print("Testing fire_rate = 0.5")
	assert(weapon.try_fire(0.0) == true, "First shot should succeed")
	assert(weapon.try_fire(1.5) == false, "Shot at 1.5s should be blocked (1.5 < 2.0)")
	assert(weapon.try_fire(2.0) == true, "Shot at 2.0s should succeed")
	
	print("All tests passed!")

func _process(_delta):
	pass