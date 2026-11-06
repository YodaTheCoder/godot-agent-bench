extends Node

func _ready() -> void:
	print("Testing health fix...")
	
	# Test 1: max_health = 100, damage(10), then heal(50) → current == 100
	var health1 = Health.new()
	health1.max_health = 100
	add_child(health1)
	health1.damage(10)
	health1.heal(50)
	assert(health1.current == 100)
	print("Test 1 passed: Healing capped at max_health")
	
	# Test 2: At full health, heal(25) → current == 100
	var health2 = Health.new()
	health2.max_health = 100
	add_child(health2)
	health2.heal(25)
	assert(health2.current == 100)
	print("Test 2 passed: Full health healing works")
	
	# Test 3: max_health = 40, damage(10), then heal(100) → current == 40
	var health3 = Health.new()
	health3.max_health = 40
	add_child(health3)
	health3.damage(10)
	health3.heal(100)
	assert(health3.current == 40)
	print("Test 3 passed: Custom max_health works")
	
	# Test 4: damage(100) (dead), then heal(20) → current == 0
	var health4 = Health.new()
	health4.max_health = 100
	add_child(health4)
	health4.damage(100)
	assert(health4.current == 0)
	health4.heal(20)
	assert(health4.current == 0)
	print("Test 4 passed: Dead entity cannot be healed")
	
	print("All tests passed!")

func _process(_delta) -> void:
	# This is just to make sure we're in a running Godot environment
	pass