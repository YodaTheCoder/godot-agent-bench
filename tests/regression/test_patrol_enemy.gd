extends GutTest

func test_patrol_enemy_creation():
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	assert_is_instance_of(patrol_enemy, PatrolEnemy)
	assert_is_instance_of(patrol_enemy, Enemy)
	assert_true(patrol_enemy.has_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)

func test_patrol_movement():
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	
	# Place the enemy at the first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process multiple times to move through waypoints
	for i in range(10):
		patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should have moved to next waypoint
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Move again to reach second waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	for i in range(10):
		patrol_enemy._physics_process(1.0 / 60.0)
	
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Move again to reach third waypoint
	patrol_enemy.global_position = Vector2(100, 100)
	for i in range(10):
		patrol_enemy._physics_process(1.0 / 60.0)
	
	assert_eq(patrol_enemy.next_waypoint_index(), 0)

func test_arrival_at_waypoint():
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	
	# Place the enemy at position (3, 0) which should be considered as arrived at waypoint (0, 0)
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should have moved to next waypoint
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

func test_chasing_behavior():
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0)])
	
	# Set up a target
	var target = Node2D.new()
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	# Test that we are not chasing when target is outside aggro range
	patrol_enemy.aggro_range = 90.0  # Target is 100px away but aggro range is 90
	assert_false(patrol_enemy.is_chasing())
	
	# Move target inside aggro range
	target.global_position = Vector2(50, 0)
	patrol_enemy.aggro_range = 100.0  # Target is 50px away
	assert_true(patrol_enemy.is_chasing())
	
	# Test that the enemy chases and velocity changes towards target
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	# Should be moving towards the target (velocity should have magnitude of speed)
	assert_eq(patrol_enemy.velocity.length(), patrol_enemy.speed)
	
	# Test that the waypoint index is not changed while chasing
	var original_index = patrol_enemy.next_waypoint_index()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), original_index)

func test_idle_behavior():
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	
	# With no waypoints and no target, should be idle
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)

func test_velocity_direction():
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	patrol_enemy.waypoints = PackedVector2Array([Vector2(300, 0)])
	
	# Place enemy at (0, 0) with waypoint at (300, 0)
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Velocity should point towards waypoint and have magnitude of speed
	assert_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0))
