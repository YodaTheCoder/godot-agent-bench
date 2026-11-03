extends Node

func test_patrol_enemy_instantiation():
	var patrol_enemy = preload("res://scenes/patrol_enemy.tscn").instantiate()
	assert(patrol_enemy is PatrolEnemy)
	assert(patrol_enemy is Enemy)
	assert(patrol_enemy.has_node("Health"))
	assert(patrol_enemy.aggro_range == 150.0)
	assert(patrol_enemy.next_waypoint_index() == 0)
	print("✓ Patrol enemy instantiation test passed")

func test_patrol_movement():
	var patrol_enemy = preload("res://scenes/patrol_enemy.tscn").instantiate()
	patrol_enemy.waypoints = [Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	
	# Test initial waypoint
	assert(patrol_enemy.next_waypoint_index() == 0)
	
	# Move to first waypoint
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert(patrol_enemy.next_waypoint_index() == 1)
	
	# Test reaching second waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert(patrol_enemy.next_waypoint_index() == 2)
	
	# Test wrapping around to first waypoint
	patrol_enemy.global_position = Vector2(100, 100)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert(patrol_enemy.next_waypoint_index() == 0)
	
	print("✓ Patrol movement test passed")

func test_arrival_check():
	var patrol_enemy = preload("res://scenes/patrol_enemy.tscn").instantiate()
	patrol_enemy.waypoints = [Vector2(0, 0)]
	patrol_enemy.global_position = Vector2(3, 0)  # Within 4 pixel threshold
	
	patrol_enemy._physics_process(1.0 / 60.0)
	assert(patrol_enemy.next_waypoint_index() == 1)
	
	print("✓ Arrival check test passed")

func test_chasing_behavior():
	var patrol_enemy = preload("res://scenes/patrol_enemy.tscn").instantiate()
	var target = Node2D.new()
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	# Test not chasing when target is outside aggro range
	patrol_enemy.aggro_range = 50.0
	patrol_enemy.global_position = Vector2(0, 0)
	assert(not patrol_enemy.is_chasing())
	
	# Test chasing when target is inside aggro range
	patrol_enemy.aggro_range = 150.0
	assert(patrol_enemy.is_chasing())
	
	# Test not chasing when target is outside range after changing range
	patrol_enemy.aggro_range = 250.0  
	patrol_enemy.global_position = Vector2(200, 0)
	assert(not patrol_enemy.is_chasing())
	
	print("✓ Chasing behavior test passed")

func test_chase_velocity():
	var patrol_enemy = preload("res://scenes/patrol_enemy.tscn").instantiate()
	patrol_enemy.speed = 100.0
	var target = Node2D.new()
	target.global_position = Vector2(300, 400)
	patrol_enemy.target = target
	
	patrol_enemy.aggro_range = 500.0  # Ensure we're chasing
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	var expected_velocity = Vector2(300, 400).normalized() * 100.0
	assert(patrol_enemy.velocity == expected_velocity)
	
	print("✓ Chase velocity test passed")

func test_idle_behavior():
	var patrol_enemy = preload("res://scenes/patrol_enemy.tscn").instantiate()
	patrol_enemy.waypoints = []
	patrol_enemy.target = null
	
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	
	assert(patrol_enemy.velocity == Vector2.ZERO)
	assert(patrol_enemy.next_waypoint_index() == 0)
	
	print("✓ Idle behavior test passed")

func _ready():
	test_patrol_enemy_instantiation()
	test_patrol_movement()
	test_arrival_check()
	test_chasing_behavior()
	test_chase_velocity()
	test_idle_behavior()
	print("All patrol enemy tests passed!")