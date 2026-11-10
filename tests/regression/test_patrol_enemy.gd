extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	pass


func test_inherits_from_enemy() -> void:
	assert_true(patrol_enemy is Enemy)
	assert_eq(patrol_enemy.points, 10)
	assert_eq(patrol_enemy.speed, 80.0)


func test_waypoints_and_aggro_range() -> void:
	var waypoints = PackedVector2Array(Vector2(0, 0), Vector2(100, 0), Vector2(100, 100))
	patrol_enemy.waypoints = waypoints
	patrol_enemy.aggro_range = 150.0
	
	assert_eq(patrol_enemy.waypoints, waypoints)
	assert_eq(patrol_enemy.aggro_range, 150.0)


func test_next_waypoint_index_starts_at_zero() -> void:
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_is_chasing_returns_false_with_no_target() -> void:
	assert_false(patrol_enemy.is_chasing())


func test_is_chasing_returns_true_when_target_is_close() -> void:
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Target is 100px away - should be inside aggro range (150px)
	assert_true(patrol_enemy.is_chasing())


func test_is_chasing_returns_false_when_target_is_far() -> void:
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(200, 0)
	patrol_enemy.target = target
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Target is 200px away - should be outside aggro range (150px)
	assert_false(patrol_enemy.is_chasing())


func test_is_chasing_updates_with_changed_aggro_range() -> void:
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(200, 0)
	patrol_enemy.target = target
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Initially outside aggro range (150px)
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range to 250px - now should be inside
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_patrolling_behavior() -> void:
	var waypoints = PackedVector2Array(Vector2(0, 0), Vector2(100, 0), Vector2(100, 100))
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process to move to next waypoint
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


func test_patrolling_arrival_at_waypoint() -> void:
	var waypoints = PackedVector2Array(Vector2(0, 0), Vector2(300, 0))
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should be at waypoint 0 initially
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Move to waypoint 1 (within 4px threshold)
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should have moved to waypoint 1
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_patrolling_velocity_towards_waypoint() -> void:
	var waypoints = PackedVector2Array(Vector2(0, 0), Vector2(300, 0))
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should move towards waypoint at speed
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2(80, 0))


func test_chasing_behavior() -> void:
	var waypoints = PackedVector2Array(Vector2(0, 0), Vector2(100, 0))
	patrol_enemy.waypoints = waypoints
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(50, 0)
	patrol_enemy.target = target
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should be chasing (within aggro range)
	assert_true(patrol_enemy.is_chasing())
	
	# Should move towards target at speed
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2(80, 0))
	
	# Next waypoint should not change while chasing
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_idle_behavior_with_no_waypoints() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should be idle with no waypoints
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_initialization_with_defaults() -> void:
	var instantiated = load("res://scenes/patrol_enemy.tscn").instantiate()
	assert_true(instantiated is PatrolEnemy)
	assert_true(instantiated is Enemy)
	assert_eq(instantiated.aggro_range, 150.0)
	assert_eq(instantiated.next_waypoint_index(), 0)