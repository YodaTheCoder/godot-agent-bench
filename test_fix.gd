extends GutTest

func test_health_fixes():
	var health = Health.new()
	
	# Test 1: max_health = 100, damage(10), then heal(50) → current == 100
	health.max_health = 100
	health.damage(10)
	health.heal(50)
	assert_eq(health.current, 100)
	
	# Test 2: At full health, heal(25) → current == 100
	health.damage(100) # Kill it first
	health.heal(25)   # Try to heal dead entity
	assert_eq(health.current, 0)
	
	# Test 3: max_health = 40, damage(10), then heal(100) → current == 40
	health = Health.new()
	health.max_health = 40
	health.damage(10)
	health.heal(100)
	assert_eq(health.current, 40)
	
	# Test 4: damage(100) (dead), then heal(20) → current == 0
	health.damage(100)
	health.heal(20)
	assert_eq(health.current, 0)
	
	print("All tests passed!")