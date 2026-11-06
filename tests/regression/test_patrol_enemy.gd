extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func test_instantiates_correctly() -> void:
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_true(patrol_enemy.has_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
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


func test_arrival_at_waypoint() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(300, 0)]
	patrol_enemy.global_position = Vector2(3, 0)  # Within 4px of waypoint
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_movement_towards_waypoint() -> void:
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(300, 0)]
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0))


func test_is_chasing() -> void:
	var target = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	patrol_enemy.global_position = Vector2(0, 0)
	target.global_position = Vector2(100, 0)  # 100px away
	assert_true(patrol_enemy.is_chasing())
	
	target.global_position = Vector2(200, 0)  # 200px away
	assert_false(patrol_enemy.is_chasing())
	
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())


func test_chasing_behavior() -> void:
	var target = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.global_position = Vector2(0, 0)
	target.global_position = Vector2(100, 50)  # Within aggro range
	
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)  # Should not change waypoint index
	assert_true(patrol_enemy.velocity != Vector2.ZERO)


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.target = null
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)