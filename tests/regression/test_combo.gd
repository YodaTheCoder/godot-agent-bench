extends GutTest


func before_each() -> void:
	ScoreManager.reset()


func after_each() -> void:
	ScoreManager.reset()


func test_combo_increment() -> void:
	ScoreManager.add_points(10, 0.0)   # combo 1 -> score 10
	ScoreManager.add_points(10, 0.5)   # combo 2 -> score 30
	ScoreManager.add_points(10, 1.0)   # combo 3 -> score 60
	assert_eq(ScoreManager.score, 60)
	assert_eq(ScoreManager.combo, 3)


func test_combo_reset_after_gap() -> void:
	ScoreManager.add_points(10, 0.0)   # combo 1 -> score 10
	ScoreManager.add_points(10, 1.0)   # combo 2 -> score 30
	ScoreManager.add_points(10, 4.0)   # 3.0 s gap: combo back to 1 -> score 70
	assert_eq(ScoreManager.score, 70)
	assert_eq(ScoreManager.combo, 1)


func test_combo_chain() -> void:
	ScoreManager.add_points(10, 0.0)   # combo 1 -> score 10
	ScoreManager.add_points(10, 1.5)   # combo 2 -> score 30
	ScoreManager.add_points(10, 3.0)   # combo 3 -> score 60
	ScoreManager.add_points(10, 4.5)   # combo 4 -> score 100
	assert_eq(ScoreManager.score, 100)
	assert_eq(ScoreManager.combo, 4)


func test_reset_combo() -> void:
	ScoreManager.add_points(10, 0.0)   # combo 1 -> score 10
	ScoreManager.add_points(10, 1.0)   # combo 2 -> score 30
	ScoreManager.reset()               # reset combo and score
	ScoreManager.add_points(10, 1.0)   # combo 1 -> score 10
	assert_eq(ScoreManager.score, 10)
	assert_eq(ScoreManager.combo, 1)


func test_untimed_calls_still_work() -> void:
	ScoreManager.add_points(10)        # score 10
	ScoreManager.add_points(5)         # score 15
	assert_eq(ScoreManager.score, 15)
	assert_eq(ScoreManager.combo, 1)   # combo unchanged


func test_backward_compatibility() -> void:
	# Test that existing calls without time parameter still work
	ScoreManager.add_points(10)
	ScoreManager.add_points(5)
	assert_eq(ScoreManager.score, 15)