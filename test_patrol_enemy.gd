extends Node

func test_basic_functionality():
	print("Testing PatrolEnemy functionality...")
	
	# Load and instantiate the patrol enemy
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	
	# Check that it's properly instantiated as a PatrolEnemy and Enemy
	assert(patrol_enemy is PatrolEnemy)
	assert(patrol_enemy is Enemy)
	print("✓ Correct inheritance")
	
	# Test default values
	assert(patrol_enemy.aggro_range == 150.0)
	assert(patrol_enemy.next_waypoint_index() == 0)
	print("✓ Default values")
	
	# Test waypoints functionality
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.waypoints = waypoints
	
	# Set up the environment for testing
	get_tree().root.add_child(patrol_enemy)
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Test movement through waypoints
	var delta = 1.0 / 60.0
	
	# First step: should move from waypoint 0 to 1
	patrol_enemy._physics_process(delta)
	assert(patrol_enemy.next_waypoint_index() == 1)
	print("✓ Waypoint advancing")
	
	# Second step: should move from waypoint 1 to 2  
	patrol_enemy._physics_process(delta)
	assert(patrol_enemy.next_waypoint_index() == 2)
	print("✓ Waypoint advancing again")
	
	# Third step: should wrap around back to 0
	patrol_enemy._physics_process(delta)
	assert(patrol_enemy.next_waypoint_index() == 0)
	print("✓ Waypoint wrapping")
	
	# Test arrival detection
	patrol_enemy.global_position = Vector2(3, 0)  # Close to waypoint 0 (which is at 0,0)
	patrol_enemy._physics_process(delta)
	assert(patrol_enemy.next_waypoint_index() == 1)  # Should advance after arrival
	print("✓ Arrival detection works")
	
	# Test velocity calculation when not yet at waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy.waypoints = waypoints
	patrol_enemy._physics_process(delta)
	var expected_velocity = Vector2(1, 0) * patrol_enemy.speed
	assert(patrol_enemy.velocity == expected_velocity)
	print("✓ Velocity calculation correct")
	
	# Test chasing behavior
	patrol_enemy.target = Node2D.new()
	patrol_enemy.target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	assert(patrol_enemy.is_chasing() == true)
	print("✓ Chasing detection works")
	
	patrol_enemy.target.global_position = patrol_enemy.global_position + Vector2(200, 0)
	assert(patrol_enemy.is_chasing() == false)
	print("✓ Chasing detection works correctly at distance")
	
	patrol_enemy.aggro_range = 250.0
	patrol_enemy.target.global_position = patrol_enemy.global_position + Vector2(200, 0)
	assert(patrol_enemy.is_chasing() == true)
	print("✓ Chasing detection with changed range works")
	
	# Test idle behavior
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.target = null
	patrol_enemy._physics_process(delta)
	assert(patrol_enemy.velocity == Vector2.ZERO)
	assert(patrol_enemy.next_waypoint_index() == 0)
	print("✓ Idle behavior works")
	
	print("All tests passed!")

func _ready():
	test_basic_functionality()
