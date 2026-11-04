extends GutTest

var patrol_enemy_scene: PackedScene = preload("res://scenes/patrol_enemy.tscn")


func test_instantiation() -> void:
	var patrol_enemy = patrol_enemy_scene.instantiate()
	
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_true(patrol_enemy.has_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_waypoint_progression() -> void:
	var patrol_enemy = add_child_autofree(patrol_enemy_scene.instantiate())
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	
	# Start at waypoint 0, then progress through waypoints
	
	# At waypoint 0, should advance to 1
	patrol_enemy.global_position = patrol_enemy.waypoints[0]
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# At waypoint 1, should advance to 2
	patrol_enemy.global_position = patrol_enemy.waypoints[1]
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# At waypoint 2, should wrap to 0
	patrol_enemy.global_position = patrol_enemy.waypoints[2]
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# At waypoint 0 again, should advance to 1
	patrol_enemy.global_position = patrol_enemy.waypoints[0]
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_near_waypoint_arrives() -> void:
	var patrol_enemy = add_child_autofree(patrol_enemy_scene.instantiate())
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	
	# At (3, 0), waypoint at (0, 0), distance = 3 <= 4, should arrive
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_not_at_waypoint_keeps_index() -> void:
	var patrol_enemy = add_child_autofree(patrol_enemy_scene.instantiate())
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy.waypoints = PackedVector2Array([Vector2(300, 0)])
	
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_almost_eq(patrol_enemy.velocity.x, patrol_enemy.speed, 0.001)
	assert_almost_eq(patrol_enemy.velocity.y, 0, 0.001)


func test_is_chasing() -> void:
	var patrol_enemy = add_child_autofree(patrol_enemy_scene.instantiate())
	patrol_enemy.global_position = Vector2(0, 0)
	
	# No target
	assert_false(patrol_enemy.is_chasing())
	
	# Target at 100 pixels (within aggro_range of 150)
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	assert_true(patrol_enemy.is_chasing())
	
	# Target at 200 pixels (outside aggro_range of 150)
	target.global_position = Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Increase aggro_range to 250
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_chasing_keeps_index() -> void:
	var patrol_enemy = add_child_autofree(patrol_enemy_scene.instantiate())
	# Put enemy at a waypoint so it's already at the waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy.waypoints = PackedVector2Array([Vector2(100, 0), Vector2(200, 0)])
	
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(150, 0)  # Within aggro_range (distance = 50)
	patrol_enemy.target = target
	
	# Enemy is at (100, 0), target at (150, 0), distance = 50 <= 150, so chasing
	assert_true(patrol_enemy.is_chasing())
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# While chasing, index should NOT change
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_no_waypoints_no_target_idle() -> void:
	var patrol_enemy = add_child_autofree(patrol_enemy_scene.instantiate())
	patrol_enemy.global_position = Vector2(0, 0)
	
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
