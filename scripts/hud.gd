class_name HUD
extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel

var _health: Health


func _ready() -> void:
	_on_score_changed(ScoreManager.score)
	ScoreManager.score_changed.connect(_on_score_changed)


func bind_health(h: Health) -> void:
	if _health and is_instance_valid(_health) and _health.health_changed.is_connected(_on_health_changed):
		_health.health_changed.disconnect(_on_health_changed)
	_health = h
	_on_health_changed(h.current, h.max_health)
	h.health_changed.connect(_on_health_changed)


func _on_score_changed(score: int) -> void:
	score_label.text = "Score: %d" % score


func _on_health_changed(current: int, max_health: int) -> void:
	health_label.text = "HP: %d/%d" % [current, max_health]
