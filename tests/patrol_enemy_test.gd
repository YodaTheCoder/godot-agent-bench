extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_instantiation() -> void:
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	var waypoints = PackedVector2Array(Vector2(0, 0), Vector2(100, 0), Vector2(100, 100))
	patrol_enemy.waypoints = waypoints
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should advance to next waypoint
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Continue moving
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Wrap around to first waypoint
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_chasing_behavior() -> void:
	var waypoints = PackedVector2Array(Vector2(0, 0))
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Create a target
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	# Should be chasing (within aggro range)
	assert_true(patrol_enemy.is_chasing())
	
	# Move target outside aggro range
	target.global_position = Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range and test again
	patrol_enemy.aggro_range = 250.0
	target.global_position = Vector2(200, 0)
	assert_true(patrol_enemy.is_chasing())


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.global_position = Vector2(100, 100)
	
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)