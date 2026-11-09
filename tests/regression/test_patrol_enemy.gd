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
	
	# Place enemy at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Place enemy at second waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Place enemy at third waypoint
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_waypoint_arrival() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(300, 0)]
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Place enemy at waypoint
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1) # Should stay the same initially
	
	# Call again to advance past waypoint
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2) # Should advance to next


func test_chasing_behavior() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0)]
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 100)
	patrol_enemy.target = target
	
	# Enemy should not be chasing yet (too far)
	assert_false(patrol_enemy.is_chasing())
	
	# Move target closer
	target.global_position = Vector2(50, 50)
	assert_true(patrol_enemy.is_chasing())
	
	# Move target further away
	target.global_position = Vector2(200, 200)
	assert_false(patrol_enemy.is_chasing())
	
	# Increase aggro range
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_velocity_while_chasing() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0)]
	patrol_enemy.speed = 100.0
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	assert_true(patrol_enemy.is_chasing())
	
	# Enemy should chase target, not follow waypoints
	var initial_waypoint_index = patrol_enemy.next_waypoint_index()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), initial_waypoint_index) # Should not change


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = []
	patrol_enemy.target = null
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)