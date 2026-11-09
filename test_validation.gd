extends Node

func test_health_fix():
	var health = Health.new()
	
	# Test 1: max_health = 100, damage(10), then heal(50) → current == 100
	health.max_health = 100
	health.damage(10)
	health.heal(50)
	assert(health.current == 100)
	print("✅ Test 1 passed: Healing capped at max_health")
	
	# Test 2: At full health, heal(25) → current == 100
	health.damage(50) # Reduce to 50
	health.heal(100) # Heal beyond max
	assert(health.current == 100)
	print("✅ Test 2 passed: Healing beyond max sets to max_health")
	
	# Test 3: max_health = 40, damage(10), then heal(100) → current == 40
	health.max_health = 40
	health.damage(10)
	health.heal(100)
	assert(health.current == 40)
	print("✅ Test 3 passed: Custom max_health works correctly")
	
	# Test 4: damage(100) (dead), then heal(20) → current == 0
	health.damage(100) # Kill entity
	health.heal(20)
	assert(health.current == 0)
	print("✅ Test 4 passed: Dead entity cannot be healed")
	
	# Test 5: Normal healing works as before
	health.max_health = 100
	health.damage(30)
	health.heal(20)
	assert(health.current == 70)
	print("✅ Test 5 passed: Normal healing still works")
	
	print("\n🎉 All tests passed! The health component fix is working correctly.")

func _ready() -> void:
	test_health_fix()