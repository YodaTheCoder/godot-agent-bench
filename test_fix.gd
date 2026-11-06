extends Node

func _ready() -> void:
	# Test the fix with default fire_rate = 4.0
	var weapon = Weapon.new()
	
	# Test case 1: With default fire_rate = 4.0
	print("Test 1: fire_rate = 4.0")
	print("try_fire(0.0) =", weapon.try_fire(0.0))  # Should be true
	print("try_fire(0.2) =", weapon.try_fire(0.2))  # Should be false
	print("try_fire(0.25) =", weapon.try_fire(0.25))  # Should be true
	
	# Test case 2: With fire_rate = 2.0
	weapon.fire_rate = 2.0
	print("\nTest 2: fire_rate = 2.0")
	print("try_fire(0.0) =", weapon.try_fire(0.0))  # Should be true
	print("try_fire(0.4) =", weapon.try_fire(0.4))  # Should be false
	print("try_fire(0.5) =", weapon.try_fire(0.5))  # Should be true
	
	# Test case 3: With fire_rate = 0.5 (one shot every 2s)
	weapon.fire_rate = 0.5
	print("\nTest 3: fire_rate = 0.5")
	print("try_fire(0.0) =", weapon.try_fire(0.0))  # Should be true
	print("try_fire(1.5) =", weapon.try_fire(1.5))  # Should be false
	print("try_fire(2.0) =", weapon.try_fire(2.0))  # Should be true
	
	print("\nDone testing")

func _process(delta: float) -> void:
	pass