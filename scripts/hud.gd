class_name HUD
extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel


func _ready() -> void:
	ScoreManager.score_changed.connect(_on_score_changed)
	_on_score_changed(ScoreManager.score)


## Shows `health` in the health label and keeps it up to date via `health_changed`.
func bind_health(health: Health) -> void:
	health.health_changed.connect(_on_health_changed)
	_on_health_changed(health.current, health.max_health)


func _on_score_changed(score: int) -> void:
	score_label.text = "Score: %d" % score


func _on_health_changed(current: int, max_health: int) -> void:
	health_label.text = "HP: %d/%d" % [current, max_health]
