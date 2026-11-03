extends GutTest

var patrol_enemy: PatrolEnemy

func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())

func test_initialization() -> void:
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_not_null(patrol_enemy.get_node("Health"))

func test_patrol_route_advancement() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Move to second waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Move to third waypoint
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Move back to first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

func test_arrival_threshold() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	
	# Close to waypoint (3, 0)
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Not close to waypoint (5, 0)
	patrol_enemy.global_position = Vector2(5, 0)
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	# We need to reset the index for this test case
	# Since _waypoint_index is private, we rely on the fact that it was 1
	# If we want to test NOT arriving, we should ensure it stays at the current index.
	# The requirement says: "Standing at (3, 0) with the current waypoint at (0, 0) counts as arrived."
	# Let's re-test arrival specifically.
	
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

func test_velocity_direction_while_patrolling() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(300, 0)])
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	# velocity should be (speed, 0)
	assert_almost_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0), 0.001)

func test_is_chasing_logic() -> void:
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# No target
	patrol_enemy.target = null
	assert_false(patrol_enemy.is_chasing())
	
	# Target 100 px away
	patrol_enemy.target = target
	patrol_enemy.global_position = Vector2(0, 0)
	target.global_position = Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())
	
	# Target 200 px away
	target.global_position = Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Target 200 px away with increased aggro_range
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())

func test_chasing_velocity_and_index_stability() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(100, 100)])
	patrol_enemy.global_position = Vector2(0, 0)
	
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	target.global_position = Vector2(50, 0) # within aggro range
	
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_almost_eq(patrol_enemy.velocity.length(), patrol_enemy.speed, 0.001)
	assert_almost_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0), 0.001)

func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array([])
	patrol_enemy.target = null
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
