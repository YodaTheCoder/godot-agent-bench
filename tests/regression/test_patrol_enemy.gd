extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_is_patrol_enemy() -> void:
	assert_is(patrol_enemy, PatrolEnemy)
	assert_is(patrol_enemy, Enemy)


func test_has_health_child() -> void:
	assert_is(patrol_enemy.get_node("Health"), Health)


func test_default_aggro_range() -> void:
	assert_eq(patrol_enemy.aggro_range, 150.0)


func test_default_next_waypoint_index() -> void:
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_waypoints_patrol_in_order() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	patrol_enemy.global_position = Vector2(0, 0)
	var index_after := patrol_enemy.next_waypoint_index()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 3 % patrol_enemy.waypoints.size())


func test_arrival_tolerance() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_no_arrival_not_at_waypoint() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(300, 0)])
	patrol_enemy.global_position = Vector2(0, 0)
	var velocity_before := patrol_enemy.velocity
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0))


func test_idle_with_no_waypoints() -> void:
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_no_target_is_not_chasing() -> void:
	assert_false(patrol_enemy.is_chasing())


func test_is_chasing_within_range() -> void:
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	target.global_position = Vector2(0, 100)
	assert_true(patrol_enemy.is_chasing())
	
	target.global_position = Vector2(0, 200)
	assert_false(patrol_enemy.is_chasing())
	
	target.global_position = Vector2(500, 0)
	assert_false(patrol_enemy.is_chasing())

	patrol_enemy.aggro_range = 250.0
	target.global_position = Vector2(0, 200)
	assert_true(patrol_enemy.is_chasing())


func test_chasing_velocity_unchanged_waypoint_index() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(300, 0)])
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy.next_waypoint_index()
	var waypoints_before_index := patrol_enemy.next_waypoint_index()
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	target.global_position = Vector2(0, 50)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), waypoints_before_index)