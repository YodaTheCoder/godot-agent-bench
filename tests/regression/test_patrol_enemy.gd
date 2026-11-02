extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_instantiation() -> void:
	assert_is_instance_of(patrol_enemy, PatrolEnemy)
	assert_is_instance_of(patrol_enemy, Enemy)
	assert_not_null(patrol_enemy.get_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Move to second waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Move to third waypoint and wrap around
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_at_waypoint() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(300, 0)]
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1) # Should have moved to next waypoint


func test_direction_to_waypoint() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(300, 0)]
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0))


func test_is_chasing() -> void:
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# No target
	patrol_enemy.target = null
	assert_false(patrol_enemy.is_chasing())
	
	# Target within aggro range
	patrol_enemy.target = target
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
	target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	patrol_enemy.target = target
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should be chasing
	assert_true(patrol_enemy.is_chasing())
	
	# While chasing, velocity should point to target
	patrol_enemy._physics_process(1.0 / 60.0)
	var expected_velocity = patrol_enemy.direction_to_target() * patrol_enemy.speed
	assert_almost_eq(patrol_enemy.velocity, expected_velocity, Vector2(0.01, 0.01))
	
	# Waypoint index should not change while chasing
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = []
	patrol_enemy.target = null
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)