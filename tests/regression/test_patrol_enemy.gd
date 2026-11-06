extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_patrol_enemy_instantiates_correctly() -> void:
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_true(patrol_enemy.has_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should move towards first waypoint
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


func test_arrival_at_waypoint() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should advance to next waypoint when close enough
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Check velocity towards new waypoint
	var expected_velocity := Vector2(patrol_enemy.speed, 0)
	assert_almost_eq(patrol_enemy.velocity, expected_velocity, 0.001)


func test_chasing_behavior() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(50, 0) # Within aggro range
	patrol_enemy.target = target
	
	# Should be chasing since target is within aggro range
	assert_true(patrol_enemy.is_chasing())
	
	# Velocity should point towards target
	patrol_enemy._physics_process(1.0 / 60.0)
	var expected_velocity := Vector2(patrol_enemy.speed, 0)
	assert_almost_eq(patrol_enemy.velocity, expected_velocity, 0.001)


func test_idle_behavior() -> void:
	# Empty waypoints should make enemy idle
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_chase_vs_patrol() -> void:
	# Set waypoints and a target within aggro range
	var waypoints := PackedVector2Array([Vector2(0, 0)])
	patrol_enemy.waypoints = waypoints
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0) # Within aggro range of 150
	patrol_enemy.target = target
	
	# Enemy should be chasing, and waypoint index shouldn't change while chasing
	var initial_waypoint_index := patrol_enemy.next_waypoint_index()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), initial_waypoint_index)


func test_is_chasing_logic() -> void:
	patrol_enemy.aggro_range = 150.0
	var target: Node2D = add_child_autofree(Node2D.new())
	
	# No target - should not be chasing
	assert_false(patrol_enemy.is_chasing())
	
	# Set target at 100px distance - should be chasing
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	assert_true(patrol_enemy.is_chasing())
	
	# Move target beyond aggro range - should not be chasing
	target.global_position = Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range to 250 and move target to 200px - should be chasing
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())