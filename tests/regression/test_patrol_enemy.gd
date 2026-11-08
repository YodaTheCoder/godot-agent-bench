extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_instantiates_correctly() -> void:
	assert_eq(patrol_enemy, patrol_enemy as PatrolEnemy)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_true(patrol_enemy.has_node("Health"))


func test_patrol_movement() -> void:
	var waypoints = [Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	patrol_enemy.waypoints = waypoints
	
	# Test patrol movement
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_at_waypoint() -> void:
	var waypoints = [Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.waypoints = waypoints
	
	# Place enemy at waypoint position
	patrol_enemy.global_position = Vector2(3, 0)  # Within 4px threshold
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_chasing_behavior() -> void:
	var waypoints = [Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.waypoints = waypoints
	
	# Test chase behavior
	var target = add_child_autofree(Node2D.new())
	target.global_position = Vector2(50, 0)
	patrol_enemy.target = target
	
	# Should be chasing since target is within aggro range
	assert_true(patrol_enemy.is_chasing())
	
	# Set enemy position and check velocity
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Check that we're moving towards the target (not waypoint) with correct speed
	var expected_velocity = patrol_enemy.direction_to_target() * patrol_enemy.speed
	assert_almost_eq(patrol_enemy.velocity, expected_velocity, Vector2(0.001, 0.001))
	assert_eq(patrol_enemy.next_waypoint_index(), 0)  # Should not change


func test_aggro_range_logic() -> void:
	var target = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# Target 100px away - should be chasing
	target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())
	
	# Target 200px away - should not be chasing
	target.global_position = patrol_enemy.global_position + Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Change aggro range to 250px
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)