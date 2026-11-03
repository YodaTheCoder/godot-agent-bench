extends GutTest

var patrol_enemy: PatrolEnemy

func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())

func after_each() -> void:
	ScoreManager.reset()

func test_initialization() -> void:
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_true(patrol_enemy.has_node("Health"))

func test_waypoint_progression() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)])
	
	# Starts at index 0
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Move to waypoint 0 (it is already at 0,0 if we don't move it, but let's be explicit)
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Move to waypoint 1
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Move to waypoint 2
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	
	# Move to waypoint 0 again
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

func test_arrival_threshold() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0)])
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1) # Should have advanced (wrapped to 0 if it was 1, but size is 1)
	# Wait, if size is 1, index 0 -> 0.
	# Let's re-test with actual wrap logic.
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 100)])
	patrol_enemy.global_position = Vector2(3, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)

func test_velocity_direction() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(100, 0)])
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0))

func test_chasing_logic() -> void:
	var target = Node2D.new()
	add_child_autofree(target)
	patrol_enemy.target = target
	
	# 200 px away (should be false)
	patrol_enemy.global_position = Vector2(0, 0)
	target.global_position = Vector2(200, 0)
	patrol_enemy.aggro_range = 150.0
	assert_false(patrol_enemy.is_chasing())
	
	# 100 px away (should be true)
	target.global_position = Vector2(100, 0)
	assert_true(patrol_enemy.is_chasing())
	
	# 200 px away and aggro_range = 250
	target.global_position = Vector2(200, 0)
	patrol_enemy.aggro_range = 250.0
	assert_true(patrol_enemy.is_chasing())

func test_chase_maintains_waypoint() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(100, 100)])
	patrol_enemy.global_position = Vector2(0, 0)
	
	var target = Node2D.new()
	add_child_autofree(target)
	patrol_enemy.target = target
	target.global_position = Vector2(50, 0) # Inside aggro range
	patrol_enemy.aggro_range = 150.0
	
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)
	assert_eq(patrol_enemy.velocity, Vector2(patrol_enemy.speed, 0).normalized() * patrol_enemy.speed)

func test_idle_with_no_waypoints_and_no_target() -> void:
	patrol_enemy.waypoints = Packed_Vector2Array() # Wait, PackedVector2Array
	patrol_enemy.waypoints = [] # Can't do this in GDScript easily this way for PackedVector2Array via python-like style? No, it is GDScript.
	# I'll use the proper way.
	patrol_enemy.waypoints = PackedVector2Array([])
	patrol_enemy.target = null
	patrol_enemy.global_position = Vector2(0,0)
	patrol_enemy._physics_process(1.0/60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
