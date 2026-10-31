extends Node

func _ready() -> void:
	var weapon = Weapon.new()
	
	# Test with default fire_rate = 4.0 (should fire every 0.25 seconds)
	print("Testing default fire_rate = 4.0")
	print("try_fire(0.0) =", weapon.try_fire(0.0)) # Should be true
	print("try_fire(0.2) =", weapon.try_fire(0.2)) # Should be false (not enough time passed)
	print("try_fire(0.25) =", weapon.try_fire(0.25)) # Should be true (enough time passed)
	
	# Test with fire_rate = 2.0 (should fire every 0.5 seconds)
	print("\nTesting fire_rate = 2.0")
	var weapon2 = Weapon.new()
	weapon2.fire_rate = 2.0
	print("try_fire(0.0) =", weapon2.try_fire(0.0)) # Should be true
	print("try_fire(0.4) =", weapon2.try_fire(0.4)) # Should be false (not enough time passed)
	print("try_fire(0.5) =", weapon2.try_fire(0.5)) # Should be true (enough time passed)
	
	# Test with fire_rate = 0.5 (should fire every 2 seconds)
	print("\nTesting fire_rate = 0.5")
	var weapon3 = Weapon.new()
	weapon3.fire_rate = 0.5
	print("try_fire(0.0) =", weapon3.try_fire(0.0)) # Should be true
	print("try_fire(1.5) =", weapon3.try_fire(1.5)) # Should be false (not enough time passed)
	print("try_fire(2.0) =", weapon3.try_fire(2.0)) # Should be true (enough time passed)

func _process(delta: float) -> void:
	queue_free()