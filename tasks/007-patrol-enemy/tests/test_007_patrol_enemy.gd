extends GutTest

const SCENE := "res://scenes/patrol_enemy.tscn"


func _make_enemy(points: PackedVector2Array) -> PatrolEnemy:
	var enemy: PatrolEnemy = load(SCENE).instantiate()
	enemy.waypoints = points
	add_child_autofree(enemy)
	return enemy


func _square() -> PackedVector2Array:
	return PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])


func test_scene_instantiates_as_patrol_enemy() -> void:
	var enemy: Node = add_child_autofree(load(SCENE).instantiate())
	assert_is(enemy, PatrolEnemy)
	assert_is(enemy, Enemy)
	assert_is(enemy.get_node("Health"), Health)
	assert_almost_eq(enemy.aggro_range, 150.0, 0.0001)
	assert_eq(enemy.next_waypoint_index(), 0)


func test_starts_heading_to_first_waypoint_and_moves_towards_it() -> void:
	var enemy := _make_enemy(PackedVector2Array([Vector2(300, 0), Vector2(300, 300)]))
	enemy.global_position = Vector2.ZERO
	enemy._physics_process(1.0 / 60.0)
	assert_eq(enemy.next_waypoint_index(), 0, "not there yet")
	assert_almost_eq(enemy.velocity, Vector2(enemy.speed, 0), Vector2(0.01, 0.01))


func test_cycles_through_waypoints_in_order() -> void:
	var points := _square()
	var enemy := _make_enemy(points)
	var seen := [enemy.next_waypoint_index()]
	for _i in 4:
		enemy.global_position = points[enemy.next_waypoint_index()]
		enemy._physics_process(1.0 / 60.0)
		seen.append(enemy.next_waypoint_index())
	assert_eq(seen, [0, 1, 2, 0, 1])


func test_arrival_within_four_pixels_advances() -> void:
	var enemy := _make_enemy(_square())
	enemy.global_position = Vector2(3, 0)
	enemy._physics_process(1.0 / 60.0)
	assert_eq(enemy.next_waypoint_index(), 1)


func test_is_chasing_inside_aggro_range_only() -> void:
	var enemy := _make_enemy(_square())
	var player: Node2D = add_child_autofree(Node2D.new())
	enemy.global_position = Vector2(500, 500)
	assert_false(enemy.is_chasing(), "no target")
	enemy.target = player
	player.global_position = Vector2(500, 600)
	assert_true(enemy.is_chasing(), "100 px away")
	player.global_position = Vector2(500, 700)
	assert_false(enemy.is_chasing(), "200 px away")
	enemy.aggro_range = 250.0
	assert_true(enemy.is_chasing(), "200 px away, range 250")


func test_chasing_moves_towards_target_and_keeps_waypoint() -> void:
	var enemy := _make_enemy(_square())
	var player: Node2D = add_child_autofree(Node2D.new())
	enemy.target = player
	enemy.global_position = Vector2(0, 0)
	player.global_position = Vector2(0, -100)
	enemy._physics_process(1.0 / 60.0)
	assert_almost_eq(enemy.velocity, Vector2(0, -enemy.speed), Vector2(0.01, 0.01))
	assert_eq(enemy.next_waypoint_index(), 0, "waypoint unchanged while chasing")


func test_no_waypoints_and_no_target_stands_still() -> void:
	var enemy := _make_enemy(PackedVector2Array())
	enemy._physics_process(1.0 / 60.0)
	assert_eq(enemy.velocity, Vector2.ZERO)
	assert_eq(enemy.next_waypoint_index(), 0)
