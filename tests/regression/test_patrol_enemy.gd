extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_instantiation() -> void:
	assert_is_instance_of(patrol_enemy, PatrolEnemy)
	assert_is_instance_of(patrol_enemy, Enemy)
	assert_eq(patrol_enemy.get_node("Health"), patrol_enemy.health)
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.waypoints = waypoints
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Advance through waypoints
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_at_waypoint() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should be at first waypoint
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Move to within 4 pixels of the waypoint
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should have advanced to next waypoint
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_velocity_towards_waypoint() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Check that velocity is towards the waypoint with correct length
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity.length(), patrol_enemy.speed, 0.001)
	assert_almost_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0), Vector2(0.001, 0.001))


func test_is_chasing() -> void:
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# No target
	patrol_enemy.target = null
	assert_false(patrol_enemy.is_chasing())
	
	# Set target
	patrol_enemy.target = target
	
	# Target within aggro range
	target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())
	
	# Target outside aggro range
	target.global_position = patrol_enemy.global_position + Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_chasing_behavior() -> void:
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# Set up waypoints and position
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Move to target position (within aggro range)
	target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	
	# Check that velocity is towards the target and waypoint index doesn't change
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity.length(), patrol_enemy.speed, 0.001)
	assert_eq(patrol_enemy.next_waypoint_index(), 0) # Should not change


func test_idle_behavior() -> void:
	# No waypoints and no target
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)