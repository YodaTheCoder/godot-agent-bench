extends GutTest

func test_health_healing_fixes() -> void:
	# Test 1: max_health = 100, damage(10), then heal(50) → current == 100
	var health1 = Health.new()
	health1.max_health = 100
	add_child_autofree(health1)
	health1.damage(10)
	health1.heal(50)
	assert_eq(health1.current, 100)
	
	# Test 2: At full health, heal(25) → current == 100
	var health2 = Health.new()
	health2.max_health = 100
	add_child_autofree(health2)
	health2.heal(25)
	assert_eq(health2.current, 100)
	
	# Test 3: max_health = 40, damage(10), then heal(100) → current == 40
	var health3 = Health.new()
	health3.max_health = 40
	add_child_autofree(health3)
	health3.damage(10)
	health3.heal(100)
	assert_eq(health3.current, 40)
	
	# Test 4: damage(100) (dead), then heal(20) → current == 0
	var health4 = Health.new()
	health4.max_health = 100
	add_child_autofree(health4)
	health4.damage(100)
	assert_eq(health4.current, 0)
	health4.heal(20)
	assert_eq(health4.current, 0)
	
	# Test 5: Normal healing still works
	var health5 = Health.new()
	health5.max_health = 100
	add_child_autofree(health5)
	health5.damage(30)
	health5.heal(20)
	assert_eq(health5.current, 70)
	
	print("All comprehensive tests passed!")