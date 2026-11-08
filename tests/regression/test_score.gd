extends GutTest


func before_each() -> void:
	ScoreManager.reset()


func after_each() -> void:
	ScoreManager.reset()


func test_add_points_accumulates() -> void:
	ScoreManager.add_points(10)
	ScoreManager.add_points(5)
	assert_eq(ScoreManager.score, 15)


func test_reset_zeroes_score() -> void:
	ScoreManager.add_points(10)
	ScoreManager.reset()
	assert_eq(ScoreManager.score, 0)


func test_combo_multiplies_score() -> void:
	ScoreManager.reset()
	ScoreManager.add_points(10, 0.0)
	ScoreManager.add_points(10, 0.5)
	ScoreManager.add_points(10, 1.0)
	assert_eq(ScoreManager.score, 60)
	assert_eq(ScoreManager.combo, 3)


func test_combo_resets_after_gap() -> void:
	ScoreManager.reset()
	ScoreManager.add_points(10, 0.0)
	ScoreManager.add_points(10, 1.0)
	ScoreManager.add_points(10, 3.5)
	assert_eq(ScoreManager.score, 40)
	assert_eq(ScoreManager.combo, 1)


func test_combo_increments_each_call() -> void:
	ScoreManager.reset()
	ScoreManager.add_points(10, 0.0)
	ScoreManager.add_points(10, 1.5)
	ScoreManager.add_points(10, 3.0)
	ScoreManager.add_points(10, 4.5)
	assert_eq(ScoreManager.score, 100)


func test_reset_clears_combo() -> void:
	ScoreManager.add_points(10, 0.0)
	ScoreManager.add_points(10, 0.5)
	ScoreManager.reset()
	ScoreManager.add_points(10, 1.0)
	assert_eq(ScoreManager.score, 10)
	assert_eq(ScoreManager.combo, 1)
