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
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process multiple times to test waypoint progression
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should have moved to waypoint 1
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_chasing_behavior() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Set up a target
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(50, 0)  # Within aggro range
	patrol_enemy.target = target
	
	# Test that it's chasing (distance is less than aggro_range)
	assert_true(patrol_enemy.is_chasing())
	
	# Call physics process - should move towards target
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should be moving toward target, not waypoint
	assert_not_eq(patrol_enemy.velocity, Vector2.ZERO)


func test_is_chasing_behavior() -> void:
	var waypoints := PackedVector2Array([Vector2(0, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# No target
	assert_false(patrol_enemy.is_chasing())
	
	# Set up a target
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)  # Within aggro range (150)
	patrol_enemy.target = target
	
	# Should be chasing
	assert_true(patrol_enemy.is_chasing())
	
	# Move target outside aggro range
	target.global_position = Vector2(200, 0)  # Outside aggro range
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should be idle (no waypoints)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)