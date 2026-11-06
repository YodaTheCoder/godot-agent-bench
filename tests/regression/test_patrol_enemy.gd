extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_instantiates_correctly() -> void:
	assert_eq(patrol_enemy.get_script().get_path(), "res://scripts/patrol_enemy.gd")
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_true(patrol_enemy.has_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.waypoints = waypoints
	
	# Test initial waypoint
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Place enemy at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Place enemy at second waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Place enemy at third waypoint (should wrap around)
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_arrival_tolerance() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(3, 0)
	
	# Should be considered arrived (within 4px tolerance)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_chasing_behavior() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# Test not chasing (target too far)
	target.global_position = Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Test chasing (target within range)
	target.global_position = Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())
	
	# Test changing aggro_range
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_chasing_sets_velocity() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.waypoints = waypoints
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	target.global_position = Vector2(50, 0)
	
	# Set speed for predictable velocity
	patrol_enemy.speed = 100.0
	
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity.length(), 100.0, 1.0) # Speed should be set correctly


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_chasing_does_not_change_waypoint_index() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0) # Move to waypoint 1
	
	var initial_index := patrol_enemy.next_waypoint_index()
	
	# Set up chasing scenario
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	target.global_position = Vector2(50, 0)
	
	patrol_enemy._physics_process(1.0 / 60.0) # Should be chasing
	
	# Waypoint index should remain the same while chasing
	assert_eq(patrol_enemy.next_waypoint_index(), initial_index)