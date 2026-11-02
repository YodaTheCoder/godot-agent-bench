extends GutTest

var patrol_enemy: PatrolEnemy

func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())

func after_each() -> void:
	ScoreManager.reset()

func test_is_patrol_enemy() -> void:
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)

func test_has_health_child() -> void:
	assert_true(patrol_enemy.has_node("Health"))

func test_aggro_range_default() -> void:
	assert_eq(patrol_enemy.aggro_range, 150.0)

func test_next_waypoint_index_default() -> void:
	assert_eq(patrol_enemy.next_waypoint_index(), 0)

func test_next_waypoint_index_patrolling() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	
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

func test_is_near_waypoint_counts_as_arrived() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0)]
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

func test_not_at_waypoint_does_not_advance() -> void:
	patrol_enemy.waypoints = [Vector2(300, 0)]
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_almost_eq(patrol_enemy.velocity.x, patrol_enemy.speed, 0.001)
	assert_almost_eq(patrol_enemy.velocity.y, 0, 0.001)

func test_is_chasing_without_target() -> void:
	patrol_enemy.target = null
	assert_false(patrol_enemy.is_chasing())

func test_is_chasing_within_aggro() -> void:
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = patrol_enemy.global_position + Vector2(100, 0)
	patrol_enemy.target = target
	assert_true(patrol_enemy.is_chasing())

func test_is_chasing_outside_aggro() -> void:
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = patrol_enemy.global_position + Vector2(200, 0)
	patrol_enemy.target = target
	assert_false(patrol_enemy.is_chasing())

func test_is_chasing_after_aggro_increase() -> void:
	patrol_enemy.aggro_range = 250.0
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = patrol_enemy.global_position + Vector2(200, 0)
	patrol_enemy.target = target
	assert_true(patrol_enemy.is_chasing())

func test_chasing_moves_towards_target() -> void:
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy.waypoints = []
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(patrol_enemy.velocity.x, patrol_enemy.speed, 0.001)
	assert_almost_eq(patrol_enemy.velocity.y, 0, 0.001)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)

func test_idle_with_no_waypoints() -> void:
	patrol_enemy.waypoints = []
	patrol_enemy.target = null
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)