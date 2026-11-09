class_name HUD
extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel


func _ready() -> void:
	score_label.text = "Score: %d" % ScoreManager.score
	ScoreManager.score_changed.connect(_on_score_changed)
	
	# Initialize health label to empty/0 value
	health_label.text = ""


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score


func bind_health(h: Health) -> void:
	# Set initial health text
	health_label.text = "HP: %d/%d" % [h.current, h.max_health]
	
	# Connect to health changes
	h.health_changed.connect(_on_health_changed)


func _on_health_changed(current: int, max_health: int) -> void:
	health_label.text = "HP: %d/%d" % [current, max_health]
