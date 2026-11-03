extends GutTest


func before_each() -> void:
	ScoreManager.reset()


func test_add_points_accumulates() -> void:
	ScoreManager.add_points(10)
	ScoreManager.add_points(5)
	assert_eq(ScoreManager.score, 15)


func test_reset_zeroes_score() -> void:
	ScoreManager.add_points(10)
	ScoreManager.reset()
	assert_eq(ScoreManager.score, 0)


func test_score_updates_on_enemy_death() -> void:
	ScoreManager.reset()

	var enemy := load("res://scenes/enemy.tscn").instantiate()
	enemy = add_child_autofree(enemy)

	var health := enemy.get_node("Health")
	health.damage(health.max_health)

	assert_eq(ScoreManager.score, enemy.points)
	assert_true(enemy.is_queued_for_deletion())


extends GutTest

var enemy: Enemy


func before_each() -> void:
	ScoreManager.reset()
	enemy = add_child_autofree(load("res://scenes/enemy.tscn").instantiate())


func after_each() -> void:
	ScoreManager.reset()


func test_direction_to_target_is_normalised() -> void:
	var target: Node2D = add_child_autofree(Node2D.new())
	enemy.global_position = Vector2(10, 10)
	target.global_position = Vector2(310, 410)
	enemy.target = target
	var direction := enemy.direction_to_target()
	assert_almost_eq(direction.length(), 1.0, 0.001)
	assert_almost_eq(direction, Vector2(0.6, 0.8), Vector2(0.001, 0.001))


func test_death_awards_points_and_frees_enemy() -> void:
	var health: Health = enemy.get_node("Health")
	health.damage(health.max_health)
	assert_eq(ScoreManager.score, enemy.points)
	assert_true(enemy.is_queued_for_deletion()