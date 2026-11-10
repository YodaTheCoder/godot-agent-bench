class_name HUD
extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel


func _ready() -> void:
	score_label.text = "Score: %d" % ScoreManager.score
	# We don't need _process anymore since we'll use signals


func bind_health(h: Health) -> void:
	health_label.text = "HP: %d/%d" % [h.current, h.max_health]
	h.health_changed.connect(func(current, max_health):
		health_label.text = "HP: %d/%d" % [current, max_health]
	)
