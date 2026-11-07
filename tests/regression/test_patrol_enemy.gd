extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_instantiates_correctly() -> void:
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_eq(patrol_enemy.get_node("Health"), patrol_enemy.health)
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.waypoints = waypoints
	
	# Test initial state
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Place enemy at first waypoint and advance
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Place at second waypoint and advance
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Place at third waypoint and wrap around
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_detection() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.waypoints = waypoints
	
	# Place enemy at position that should count as "arrived"
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_movement_towards_waypoint() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process and check velocity
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0))


func test_is_chasing() -> void:
	var target = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# Test with no target
	patrol_enemy.target = null
	assert_false(patrol_enemy.is_chasing())
	
	# Test with target within range
	patrol_enemy.target = target
	target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())
	
	# Test with target outside range
	target.global_position = patrol_enemy.global_position + Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	# Test with increased aggro range
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_chasing_behavior() -> void:
	var target = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	
	# Call physics process while chasing
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, patrol_enemy.direction_to_target() * patrol_enemy.speed)
	# Test that waypoint index doesn't change during chasing
	var original_index = patrol_enemy.next_waypoint_index()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), original_index)


func test_idle_behavior() -> void:
	# Test with no waypoints and no target
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.target = null
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)