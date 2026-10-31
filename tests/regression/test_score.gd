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


func test_score_changed_emitted_on_add_and_reset() -> void:
	watch_signals(ScoreManager)
	ScoreManager.add_points(10)
	assert_signal_emitted_with_parameters(ScoreManager, "score_changed", [10], 0)
	ScoreManager.reset()
	assert_signal_emitted_with_parameters(ScoreManager, "score_changed", [0], 1)
