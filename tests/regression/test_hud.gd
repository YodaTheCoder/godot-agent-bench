extends GutTest

const HudScene := preload("res://scenes/hud.tscn")

var hud: HUD
var health: Health


func before_each() -> void:
	ScoreManager.reset()
	hud = HudScene.instantiate()
	add_child_autofree(hud)
	health = Health.new()
	health.max_health = 100
	add_child_autofree(health)


func after_each() -> void:
	ScoreManager.reset()


func test_health_label_is_child_label() -> void:
	assert_is(hud.health_label, Label)
	assert_eq(hud.health_label, hud.get_node("HealthLabel"))


func test_bind_health_sets_label_immediately() -> void:
	var h := Health.new()
	h.max_health = 40
	add_child_autofree(h)
	hud.bind_health(h)
	assert_eq(hud.health_label.text, "HP: 40/40")


func test_health_label_follows_changes() -> void:
	hud.bind_health(health)
	health.damage(30)
	assert_eq(hud.health_label.text, "HP: 70/100")
	health.heal(10)
	assert_eq(hud.health_label.text, "HP: 80/100")
	health.damage(500)
	assert_eq(hud.health_label.text, "HP: 0/100")


func test_rebinding_stops_following_old_health() -> void:
	hud.bind_health(health)
	var other := Health.new()
	other.max_health = 50
	add_child_autofree(other)
	hud.bind_health(other)
	health.damage(30)
	assert_eq(hud.health_label.text, "HP: 50/50")


func test_score_label_follows_score_manager() -> void:
	assert_eq(hud.score_label.text, "Score: 0")
	ScoreManager.add_points(10)
	assert_eq(hud.score_label.text, "Score: 10")
	ScoreManager.reset()
	assert_eq(hud.score_label.text, "Score: 0")


func test_hud_does_not_poll() -> void:
	var names: Array = hud.get_script().get_script_method_list().map(func(m): return m.name)
	assert_does_not_have(names, "_process")
	assert_does_not_have(names, "_physics_process")
