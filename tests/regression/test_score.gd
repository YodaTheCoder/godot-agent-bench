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
