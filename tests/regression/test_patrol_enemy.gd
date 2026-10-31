extends GutTest

var enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_scene_defaults() -> void:
	assert_true(enemy is Enemy)
	assert_not_null(enemy.get_node_or_null("Health"))
	assert_eq(enemy.aggro_range, 150.0)
	assert_eq(enemy.next_waypoint_index(), 0)


func test_waypoints_advance_and_wrap() -> void:
	enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	var seen: Array[int] = [enemy.next_waypoint_index()]
	for i in 4:
		enemy.global_position = enemy.waypoints[enemy.next_waypoint_index()]
		enemy._physics_process(1.0 / 60.0)
		seen.append(enemy.next_waypoint_index())
	assert_eq(seen, [0, 1, 2, 0, 1] as Array[int])


func test_within_arrive_distance_counts_as_reached() -> void:
	enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	enemy.global_position = Vector2(3, 0)
	enemy._physics_process(1.0 / 60.0)
	assert_eq(enemy.next_waypoint_index(), 1)


func test_moves_towards_waypoint_not_yet_reached() -> void:
	enemy.waypoints = PackedVector2Array([Vector2(300, 0)])
	enemy.global_position = Vector2.ZERO
	enemy._physics_process(1.0 / 60.0)
	assert_eq(enemy.next_waypoint_index(), 0)
	assert_almost_eq(enemy.velocity, Vector2(enemy.speed, 0), Vector2(0.001, 0.001))


func test_is_chasing_uses_aggro_range() -> void:
	assert_false(enemy.is_chasing())
	var target: Node2D = add_child_autofree(Node2D.new())
	enemy.target = target
	enemy.global_position = Vector2.ZERO
	target.global_position = Vector2(100, 0)
	assert_true(enemy.is_chasing())
	target.global_position = Vector2(200, 0)
	assert_false(enemy.is_chasing())
	enemy.aggro_range = 250.0
	assert_true(enemy.is_chasing())


func test_chasing_moves_at_target_and_keeps_waypoint() -> void:
	enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(500, 500)])
	var target: Node2D = add_child_autofree(Node2D.new())
	enemy.target = target
	enemy.global_position = Vector2.ZERO
	target.global_position = Vector2(0, 100)
	enemy._physics_process(1.0 / 60.0)
	assert_eq(enemy.next_waypoint_index(), 0)
	assert_almost_eq(enemy.velocity, Vector2(0, enemy.speed), Vector2(0.001, 0.001))


func test_idle_without_waypoints_or_target() -> void:
	enemy._physics_process(1.0 / 60.0)
	assert_eq(enemy.velocity, Vector2.ZERO)
	assert_eq(enemy.next_waypoint_index(), 0)


func test_death_awards_points_and_frees_enemy() -> void:
	var health: Health = enemy.get_node("Health")
	health.damage(health.max_health)
	assert_eq(ScoreManager.score, enemy.points)
	assert_true(enemy.is_queued_for_deletion())
