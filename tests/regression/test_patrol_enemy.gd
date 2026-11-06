extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_instantiation_properties() -> void:
	# Test that instantiation creates a PatrolEnemy with correct defaults
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_not_null(patrol_enemy.get_node("Health"))


func test_patrol_movement() -> void:
	# Test patrolling behavior with waypoints
	var waypoints := PackedVector2Array([
		Vector2(0, 0),
		Vector2(100, 0),
		Vector2(100, 100)
	])
	patrol_enemy.waypoints = waypoints
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Advance through waypoints
	for i in range(3):
		patrol_enemy._physics_process(1.0 / 60.0)
		assert_eq(patrol_enemy.next_waypoint_index(), (i + 1) % waypoints.size())
	
	# Check that it loops correctly
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_at_waypoint() -> void:
	# Test arrival at a waypoint (within 4.0 pixels)
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	
	# Place enemy close to first waypoint
	patrol_enemy.global_position = Vector2(3, 0)
	
	# Process physics to advance to next waypoint (should be index 1 now)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_movement_towards_waypoint() -> void:
	# Test movement toward a waypoint
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Process physics - velocity should point toward waypoint with speed magnitude
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0), Vector2(0.001, 0.001))


func test_chasing_behavior() -> void:
	# Test chasing behavior
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# Set target at 100px distance (should be within aggro range)
	target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	
	# Should be chasing
	assert_true(patrol_enemy.is_chasing())
	
	# Change aggro range to 250.0 and test
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())
	
	# Move target further away (should no longer be chasing)
	target.global_position = patrol_enemy.global_position + Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())


func test_chasing_sets_velocity_towards_target() -> void:
	# Test that chasing mode sets proper velocity
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	
	# Enable chasing by setting distance within range
	patrol_enemy.aggro_range = 150.0
	
	# Process physics - velocity should point toward target with speed magnitude
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity.length(), patrol_enemy.speed, 0.001)
	
	# Verify direction is correct (toward target)
	var expected_direction := patrol_enemy.global_position.direction_to(target.global_position)
	assert_almost_eq(patrol_enemy.velocity.normalized(), expected_direction, Vector2(0.001, 0.001))
	
	# Check that waypoint index hasn't changed while chasing
	var original_index := patrol_enemy.next_waypoint_index()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), original_index)


func test_idle_behavior() -> void:
	# Test idle behavior (no waypoints, no target)
	var prev_velocity := patrol_enemy.velocity
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)