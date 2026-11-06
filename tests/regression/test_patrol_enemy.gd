extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_instantiated_as_patrol_enemy() -> void:
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_true(patrol_enemy.has_node("Health"))


func test_patrol_movement() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = waypoints[0]
	
	# Test initial state
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Test movement to first waypoint
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Test movement to second waypoint
	patrol_enemy.global_position = waypoints[1]
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Test wrapping around
	patrol_enemy.global_position = waypoints[2]
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_at_waypoint() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)]
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(3, 0)  # Close to waypoint but not there yet
	
	# Should not have reached the waypoint yet
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Now at the waypoint position
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_chasing_behavior() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Add a target
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	# Should be chasing (distance = 100 < aggro_range = 150)
	assert_true(patrol_enemy.is_chasing())
	
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# While chasing, it should move towards the target, not the waypoint
	# Check that next waypoint index did not change
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Test changing aggro_range
	patrol_enemy.aggro_range = 250.0
	target.global_position = Vector2(200, 0)  # Distance = 200 now
	
	# Should still be chasing (distance = 200 < aggro_range = 250)
	assert_true(patrol_enemy.is_chasing())
	
	patrol_enemy.aggro_range = 100.0   # Reduce the range
	target.global_position = Vector2(200, 0)  # Distance = 200 still
	
	# Should no longer be chasing (distance = 200 > aggro_range = 100)
	assert_false(patrol_enemy.is_chasing())


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.global_position = Vector2(100, 100)
	
	# Should be idle with no waypoints
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_velocity_when_not_chasing() -> void:
	var waypoints = PackedVector2Array([Vector2(300, 0)]
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should point towards the waypoint with speed magnitude
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Check that the velocity has correct direction (unit vector along x-axis) and magnitude (speed)
	assert_almost_eq(patrol_enemy.velocity.length(), patrol_enemy.speed, 0.001)
	assert_almost_eq(patrol_enemy.velocity.x, patrol_enemy.speed, 0.001)
	assert_almost_eq(patrol_enemy.velocity.y, 0.0, 0.001)