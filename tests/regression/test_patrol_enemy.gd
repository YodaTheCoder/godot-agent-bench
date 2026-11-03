extends GutTest

var patrol_enemy: PatrolEnemy


func before_each() -> void:
	ScoreManager.reset()
	patrol_enemy = add_child_autofree(load("res://scenes/patrol_enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_instantiation() -> void:
	assert_is_instance_of(patrol_enemy, PatrolEnemy)
	assert_is_instance_of(patrol_enemy, Enemy)
	assert_true(patrol_enemy.has_node("Health"))
	assert_eq(patrol_enemy.aggro_range, 150.0)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_patrol_movement() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0), Vector2(100, 100)]
	patrol_enemy.waypoints = waypoints
	
	# Start at first waypoint
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


func test_arrived_at_waypoint() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(300, 0)]
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(3, 0)  # Within 4 pixel threshold
	
	patrol_enemy._physics_process(1.0 / 60.0)
	
	# Should have moved to next waypoint
	assert_eq(patrol_enemy.next_waypoint_index(), 1)


func test_chasing_behavior() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0), Vector2(100, 0)]
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Create a target
	var target: Node2D = add_child_autofree(Node2D.new())
	target.global_position = Vector2(100, 0)  # Within aggro range
	patrol_enemy.target = target
	
	# Should be chasing (distance is 100 < 150)
	assert_eq(patrol_enemy.is_chasing(), true)
	
	# Call physics process and make sure velocity points towards target
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_not_eq(patrol_enemy.velocity, Vector2.ZERO)
	
	# Index should not change while chasing
	var index_before = patrol_enemy.next_waypoint_index()
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.next_waypoint_index(), index_before)


func test_chasing_range() -> void:
	var waypoints = PackedVector2Array([Vector2(0, 0)]
	patrol_enemy.waypoints = waypoints
	patrol_enemy.global_position = Vector2(0, 0)
	
	# Create a target
	var target: Node2D = add_child_autofree(Node2D.new())
	patrol_enemy.target = target
	
	# Target at 100 px distance - should be inside aggro range
	target.global_position = Vector2(100, 0)
	assert_eq(patrol_enemy.is_chasing(), true)
	
	# Target at 200 px distance - should be outside aggro range
	target.global_position = Vector2(200, 0)
	assert_eq(patrol_enemy.is_chasing(), false)
	
	# Change aggro range to 250
	patrol_enemy.aggro_range = 250.0
	assert_eq(patrol_enemy.is_chasing(), true)


func test_idle_behavior() -> void:
	patrol_enemy.waypoints = PackedVector2Array()
	patrol_enemy.global_position = Vector2(0, 0)
	patrol_enemy._physics_process(1.0 / 60.0)
	assert_eq(patrol_enemy.velocity, Vector2.ZERO)
	assert_eq(patrol_enemy.next_waypoint_index(), 0)


func test_death_awards_points_and_frees_enemy() -> void:
	var health: Health = patrol_enemy.get_node("Health")
	health.damage(health.max_health)
	assert_eq(ScoreManager.score, patrol_enemy.points)
	assert_true(patrol_enemy.is_queued_for_deletion())