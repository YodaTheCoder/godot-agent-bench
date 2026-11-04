extends Node

func main():
	print("Reproducing the exact issue from the problem statement...")
	var weapon = Weapon.new()
	
	# With default fire_rate = 4.0:
	# Expected behavior: 
	# try_fire(0.0) → true     (first shot always allowed)
	# try_fire(0.2) → false    (too early - only 0.2 seconds passed, but need 1/4 = 0.25 seconds)
	# try_fire(0.25) → true    (enough time passed: 0.25 - 0.0 = 0.25 seconds, which is >= 0.25)
	
	print("=== With fire_rate = 4.0 ===")
	print("try_fire(0.0): ", weapon.try_fire(0.0)) # Should be true
	print("try_fire(0.2): ", weapon.try_fire(0.2)) # Should be false (0.2 < 1/4 = 0.25)
	print("try_fire(0.25): ", weapon.try_fire(0.25)) # Should be true (0.25 >= 0.25)
	
	# With fire_rate = 2.0:
	# try_fire(0.0) → true
	# try_fire(0.4) → false (0.4 < 1/2 = 0.5)
	# try_fire(0.5) → true (0.5 >= 0.5)
	
	print("\n=== With fire_rate = 2.0 ===")
	weapon.fire_rate = 2.0
	print("try_fire(0.0): ", weapon.try_fire(0.0)) # Should be true
	print("try_fire(0.4): ", weapon.try_fire(0.4)) # Should be false (0.4 < 0.5)
	print("try_fire(0.5): ", weapon.try_fire(0.5)) # Should be true (0.5 >= 0.5)
	
	# With fire_rate = 0.5:
	# try_fire(0.0) → true
	# try_fire(1.5) → false (1.5 < 1/0.5 = 2.0)
	# try_fire(2.0) → true (2.0 >= 2.0)
	
	print("\n=== With fire_rate = 0.5 ===")
	weapon.fire_rate = 0.5
	print("try_fire(0.0): ", weapon.try_fire(0.0)) # Should be true
	print("try_fire(1.5): ", weapon.try_fire(1.5)) # Should be false (1.5 < 2.0)
	print("try_fire(2.0): ", weapon.try_fire(2.0)) # Should be true (2.0 >= 2.0)

func _ready():
	main()
