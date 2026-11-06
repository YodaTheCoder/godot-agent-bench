extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_instantiation() -> void:
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Call physics process multiple times to move through waypoints
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
		
	assert_eq(patrol_enemy.next_waypoint_index(), 1)
	
	# Move to second waypoint
	patrol_enemy.global_position = Vector2(100, 0)
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
		
	assert_eq(patrol_enemy.next_waypoint_index(), 2)
	
	# Move to third waypoint
	patrol_enemy.global_position = Vector2(100, 100)
	for i in range(5):
		patrol_enemy._physics_process(1.0 / 60.0)
		
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_arrival_at_waypoint() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)])
	patrol_enemy.global_position = Vector2(3, 0)
	
	# Should be considered at waypoint since distance <= 4.0
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_chasing_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0)])
	patrol_enemy.global_position = Vector2(0, 0)
	
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)
	patrol_enemy.target = target
	
	# Should be chasing since distance < aggro_range
	assert_eq(patrol_enemy.is_chasing(), true)
	
	# This should use direction to target and not change waypoint index
	var original_waypoint_index = patrol_enemy.next_waypoint_index()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), original_waypoint_index)
	assert_eq(patrol_enemy.velocity.length(), patrol_enemy.speed)


func test_chasing_range() -> void:
	patrol_enemy.waypoints = PackedVector2Array([Vector2(0, 0)])
	patrol_enemy.global_position = Vector2(0, 0)
	
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(200, 0)
	patrol_enemy.target = target
	
	# Should not be chasing since distance > aggro_range (150.0)
	assert_eq(patrol_enemy.is_chasing(), false)
	
	# Increase aggro range
	patrol_enemy.aggro_range = 250.0
	assert_eq(patrol_enemy.is_chasing(), true)


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array([])  # Empty waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Should be idle (velocity = Vector2.ZERO)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)