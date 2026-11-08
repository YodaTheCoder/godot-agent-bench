extends Node

func test_patrol_enemy_creation():
	print("Testing PatrolEnemy creation...")
	
	# Create a PatrolEnemy instance
	var patrol_enemy = preload("res://scripts/patrol_enemy.gd").new()
	
	# Test 1: Check default values
	assert(patrol_enemy.waypoints == PackedVector2Array(), "Waypoints should be empty by default")
	assert(patrol_enemy.aggro_range == 150.0, "Aggro range should be 150.0 by default")
	assert(patrol_enemy._next_waypoint_index == 0, "Next waypoint index should be 0 by default")
	
	print("✓ PatrolEnemy creation and default values test passed")

func test_waypoint_navigation():
	print("Testing waypoint navigation...")
	
	# Create a PatrolEnemy instance
	var patrol_enemy = preload("res://scripts/patrol_enemy.gd").new()
	
	# Set up waypoints
	var waypoints = PackedVector2Array([
		Vector2(100, 100),
		Vector2(200, 100),
		Vector2(200, 200)
	])
	patrol_enemy.waypoints = waypoints
	
	# Test initial state
	assert(patrol_enemy.next_waypoint_index() == 0, "Should start at waypoint index 0")
	
	# Test waypoint progression
	patrol_enemy._next_waypoint_index = 1
	assert(patrol_enemy.next_waypoint_index() == 1, "Should return correct waypoint index")
	
	print("✓ Waypoint navigation test passed")

func test_chasing_behavior():
	print("Testing chasing behavior...")
	
	# Create a PatrolEnemy instance
	var patrol_enemy = preload("res://scripts/patrol_enemy.gd").new()
	
	# Test with no target
	assert(patrol_enemy.is_chasing() == false, "Should not be chasing without target")
	
	# Set up a target
	var target = preload("res://scripts/enemy.gd").new()
	patrol_enemy.target = target
	
	# Test with target but outside aggro range
	patrol_enemy.global_position = Vector2(0, 0)
	target.global_position = Vector2(200, 200)  # Beyond aggro range (150)
	assert(patrol_enemy.is_chasing() == false, "Should not be chasing when target is outside aggro range")
	
	# Test with target inside aggro range
	target.global_position = Vector2(100, 100)  # Within aggro range
	assert(patrol_enemy.is_chasing() == true, "Should be chasing when target is within aggro range")
	
	print("✓ Chasing behavior test passed")

func test_inheritance():
	print("Testing Enemy inheritance...")
	
	# Create a PatrolEnemy instance
	var patrol_enemy = preload("res://scripts/patrol_enemy.gd").new()
	
	# Check that it inherits from Enemy
	assert(patrol_enemy is Enemy, "PatrolEnemy should inherit from Enemy")
	
	# Test inherited properties
	assert(patrol_enemy.points == 10, "Should inherit points property")
	assert(patrol_enemy.speed == 80.0, "Should inherit speed property")
	
	# Test inherited methods
	assert(has_method(patrol_enemy, "direction_to_target"), "Should inherit direction_to_target method")
	
	print("✓ Enemy inheritance test passed")

func run_all_tests():
	print("Running PatrolEnemy tests...\n")
	
	test_patrol_enemy_creation()
	test_waypoint_navigation()
	test_chasing_behavior()
	test_inheritance()
	
	print("\n✓ All tests passed!")

# Run the tests
run_all_tests()