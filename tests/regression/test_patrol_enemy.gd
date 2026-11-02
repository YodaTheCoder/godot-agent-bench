extends GutTest

func test_patrol_enemy_instantiation() -> void:
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	add_child_autofree(patrol_enemy)
	
	assert_true(patrol_enemy is PatrolEnemy)
	assert_true(patrol_enemy is Enemy)
	assert_not_null(patrol_enemy.get_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_enemy_movement() -> void:
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	add_child_autofree(patrol_enemy)
	
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	
	# Test waypoint arrival and advancement
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

	# Test distance check for arrival
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)])
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

	# Test velocity when not yet at waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy.waypoints = PackedVector2Array([Vector2(300, 0)])
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.velocity, Vector2(80.0, 0))

	# Test idle
	patrol_enemy.waypoints = PackedVector2Array([])
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_enemy_chasing() -> void:
	var patrol_enemy = load("res://scenes/patrol_enemy.tscn").instantiate()
	add_child_autofree(patrol_enemy)
	
	var target = Node2D.new()
	add_child_autofree(target)
	patrol_enemy.target = target
	
	# Test is_chasing logic
	patrol_enemy.global_position = Vector2(0, 0)
	target.global_position = Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())
	
	target.global_position = Vector2(200, 0)
	assert_false(patrol_enemy.is_chasing())
	
	target.global_position = Vector2(200, 0)
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())
	
	patrol_enemy.target = null
	assert_false(patrol_enemy.is_chasing())

	# Test chasing movement (does not change waypoint index)
	patrol_enemy.waypoints = PackedVector2Array([Vector2(100, 0)])
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_eq(patrol_enemy.velocity, Vector2(80.0, 0))
	
	# Ensure velocity is towards target while chasing
	patrol_enemy.target = target
	target.global_position = Vector2(50, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.velocity, Vector2(80.0, 0))
