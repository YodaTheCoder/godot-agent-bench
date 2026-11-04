extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_instantiation() -> void:
	assert_is_instance_of(patrol_enemy, PatrolEnemy)
	assert_is_instance_of(patrol_enemy, Enemy)
	assert_true(patrol_enemy.has_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	
	# Test initial state - should be at waypoint 0
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Place enemy at first waypoint and move
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
	patrol_enemy.waypoints = [Vector2(0, 0)]
	patrol_enemy.global_position = Vector2(3, 0)  # Within 4 pixel threshold
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_velocity_direction() -> void:
	patrol_enemy.waypoints = [Vector2(300, 0)]
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	var expected_velocity = Vector2(patrol_enemy.speed, 0)
	assert_almost_eq(patrol_enemy.velocity, expected_velocity, Vector2(0.001, 0.001))


func test_is_chasing() -> void:
	patrol_enemy.target = Node2D.new()
	
	# Test with no target
	patrol_enemy.target = null
	assert_false(patrol_enemy.is_chasing())
	
	# Set target at 100px distance (should be inside aggro range)
	patrol_enemy.target = add_child_autofree(Node2D.new())
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy.target.global_position = Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())
	
	# Test with target at 200px distance (should be outside aggro range)
	patrol_enemy.target.global_position = Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Test with increased aggro range
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_chase_velocity() -> void:
	var target = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	patrol_enemy.global_position = Vector2(0, 0)
	target.global_position = Vector2(100, 0)
	
	# Make sure we're in chasing state (target within range)
	assert_true(patrol_enemy.is_chasing())
	
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should move towards target with correct speed
	var expected_velocity = Vector2(patrol_enemy.speed, 0)
	assert_almost_eq(patrol_enemy.velocity, expected_velocity, Vector2(0.001, 0.001))
	
	# Make sure waypoint index is preserved during chasing
	var initial_index = patrol_enemy.next_waypoint_index()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), initial_index)


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = []
	patrol_enemy.target = null
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
