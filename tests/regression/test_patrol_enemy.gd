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
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should advance to second waypoint
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Move towards second waypoint and reach it
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Move towards third waypoint and reach it
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_distance() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(30, 0)])
	
	# Place enemy at position that should be considered "arrived" (within 4 pixels)
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_velocity_towards_waypoint() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process and check velocity
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity.length(), patrol_enemy.speed, 0.01)
	assert_almost_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0), Vector2(0.01, 0.01))


func test_chasing_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0)])
	
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 100)
	patrol_enemy.target = target
	
	# Distance is 100 px, which should be inside the aggro range (150 px)
	assert_true(patrol_enemy.is_chasing())
	
	# Move target outside aggro range
	target.global_position = Vector2(300, 300)
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro_range to include the target
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_chasing_sets_velocity() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0)])
	
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 100)
	patrol_enemy.target = target
	
	# Make sure enemy is chasing
	assert_true(patrol_enemy.is_chasing())
	
	# Call physics process and check that it moves toward the target
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity.length(), patrol_enemy.speed, 0.01)
	
	# Velocity should be pointing towards target (but can't test exact direction since that changes)


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array([])
	patrol_enemy.target = null
	
	# Should not crash and velocity should be zero
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_chasing_preserves_waypoint() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)  # Advance to second waypoint
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Set up chasing behavior
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(200, 0)
	patrol_enemy.target = target
	
	# Make sure it's chasing (distance should be 100 < aggro_range 150)
	assert_true(patrol_enemy.is_chasing())
	
	# Call physics process - should still be at second waypoint
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)