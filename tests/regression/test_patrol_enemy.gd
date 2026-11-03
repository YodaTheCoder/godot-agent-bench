extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_patrol_enemy_type() -> void:
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_not_null(patrol_enemy.get_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_behavior() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	patrol_enemy.aggro_range = 150.0
	patrol_enemy.target = null

	patrol_enemy._next_waypoint_index = 0
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
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_arrival_threshold() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0)]
	patrol_enemy.target = null

	patrol_enemy._next_waypoint_index = 0
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

	patrol_enemy._next_waypoint_index = 0
	patrol_enemy.global_position = Vector2(3, 1)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)

	patrol_enemy._next_waypoint_index = 0
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_velocity_toward_waypoint() -> void:
	patrol_enemy.waypoints = [Vector2(300, 0)]
	patrol_enemy.target = null

	patrol_enemy._next_waypoint_index = 0
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0), 0.01)


func test_is_chasing_no_target() -> void:
	patrol_enemy.waypoints = []
	patrol_enemy.target = null
	assert_false(patrol_enemy.is_chasing())


func test_is_chasing_within_range() -> void:
	patrol_enemy.waypoints = []
	patrol_enemy.target = Node2D.new()
	patrol_enemy.target.global_position = Vector2(50, 0)
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy.aggro_range = 150.0

	assert_true(patrol_enemy.is_chasing())

	patrol_enemy.global_position = Vector2(100, 0)
	assert_false(patrol_enemy.is_chasing())

	patrol_enemy.aggro_range = 250.0
	patrol_enemy.global_position = Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())


func test_chasing_does_not_change_index() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.target = Node2D.new()
	patrol_enemy.target.global_position = Vector2(0, 0)
	patrol_enemy.aggro_range = 100.0

	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_idle_no_waypoints_no_target() -> void:
	patrol_enemy.waypoints = []
	patrol_enemy.target = null
	patrol_enemy._next_waypoint_index = 0
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
