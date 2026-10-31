class_name HUD
extends CanvasLayer

@onready var score_label: Label = $ScoreLabel


func _process(_delta: float) -> void:
	score_label.text = "Score: %d" % ScoreManager.score
