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
	assert_eq(patrol_enemy.get_node("Health"), patrol_enemy.health)
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
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


func test_arrival_at_waypoint() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)]
	
	# Start at first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Arrive at second waypoint (within 4 pixel threshold)
	patrol_enemy.global_position = Vector2(300, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_chasing_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Set up a target
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	# Should be chasing (within aggro range)
	assert_true(patrol_enemy.is_chasing())
	
	# Update position to simulate chasing
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0) # Should not change waypoint while chasing


func test_chasing_distance() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0)]
	
	# Set up a target
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# Test distance thresholds
	target.global_position = Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing()) # 100px is within 150px aggro range
	
	target.global_position = Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing()) # 200px is outside 150px aggro range
	
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing()) # 200px is within 250px aggro range


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array([])
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should be idle (no waypoints and no target)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)