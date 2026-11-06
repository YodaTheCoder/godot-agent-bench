extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_instantiation() -> void:
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_not_null(patrol_enemy.get_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_behavior() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	patrol_enemy.waypoints = waypoints
	
	# Start at waypoint 0
	patrol_enemy.global_position = Vector2(0, 0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Move to next waypoint
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Continue to next waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Wrap around to first waypoint
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_chasing_behavior() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	
	# Set up a target
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(200, 0)
	patrol_enemy.target = target
	
	# Test that it's not chasing when target is too far
	patrol_enemy.global_position = Vector2(0, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Move closer to trigger chase
	target.global_position = Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())
	
	# Make sure chasing behavior sets the velocity correctly
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity.length(), patrol_enemy.speed)


func test_idle_behavior() -> void:
	# Empty waypoints array should make enemy idle
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)