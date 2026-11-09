extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_instantiation() -> void:
	assert_is_instance_of(patrol_enemy, PatrolEnemy)
	assert_is_instance_of(patrol_enemy, Enemy)
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
	
	# Should be at waypoint
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Position within 4px of waypoint
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_chasing_behavior() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Create target
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	# Within aggro range - should be chasing
	assert_true(patrol_enemy.is_chasing())
	
	# Move target outside aggro range
	target.global_position = Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.global_position = Vector2(10, 10)
	
	# Should be idle
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)