class_name HUD
extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel


func _ready() -> void:
	score_label.text = "Score: %d" % ScoreManager.score
	ScoreManager.connect("score_changed", self, "_on_score_changed")


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score


func bind_health(h: Health) -> void:
	health_label.text = "HP: %d/%d" % [h.current, h.max_health]
	h.connect("health_changed", self, "_on_health_changed")


func _on_health_changed(current: int, max_health: int) -> void:
	health_label.text = "HP: %d/%d" % [current, max_health]
