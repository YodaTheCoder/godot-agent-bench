extends GutTest


func before_each() -> void:
	ScoreManager.reset()


func after_each() -> void:
	ScoreManager.reset()


func test_three_quick_calls_build_combo() -> void:
	ScoreManager.add_points(10, 0.0)
	ScoreManager.add_points(10, 0.5)
	ScoreManager.add_points(10, 1.0)
	assert_eq(ScoreManager.score, 60)
	assert_eq(ScoreManager.combo, 3)


func test_gap_over_two_seconds_resets_multiplier() -> void:
	ScoreManager.add_points(10, 0.0)
	ScoreManager.add_points(10, 1.0)
	ScoreManager.add_points(10, 3.5)
	assert_eq(ScoreManager.score, 40)
	assert_eq(ScoreManager.combo, 1)


func test_window_is_measured_from_previous_call() -> void:
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
