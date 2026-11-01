extends Node

func _ready() -> void:
	# Test the requirements from the problem description
	var health = Health.new()
	
	# Test 1: max_health = 100, damage(10), then heal(50) → current == 100
	health.max_health = 100
	health.damage(10)
	health.heal(50)
	assert(health.current == 100, "Test 1 failed")
	print("Test 1 passed: max_health = 100, damage(10), then heal(50) → current == 100")
	
	# Test 2: At full health, heal(25) → current == 100
	health.heal(25)
	assert(health.current == 100, "Test 2 failed")
	print("Test 2 passed: At full health, heal(25) → current == 100")
	
	# Test 3: max_health = 40, damage(10), then heal(100) → current == 40
	health.max_health = 40
	health.damage(10)
	health.heal(100)
	assert(health.current == 40, "Test 3 failed")
	print("Test 3 passed: max_health = 40, damage(10), then heal(100) → current == 40")
	
	# Test 4: damage(100) (dead), then heal(20) → current == 0
	health.damage(100)
	health.heal(20)
	assert(health.current == 0, "Test 4 failed")
	print("Test 4 passed: damage(100) (dead), then heal(20) → current == 0")
	
	print("All tests passed!")