class_name Enemy
extends CharacterBody2D

@export var points := 10
@export var speed := 80.0
@export var target: Node2D

@onready var health: Health = $Health
@onready var status_effects: StatusEffects = $StatusEffects


func _ready() -> void:
	health.died.connect(_on_health_died)


func _physics_process(_delta: float) -> void:
	velocity = direction_to_target() * speed
	move_and_slide()


func direction_to_target() -> Vector2:
	if target == null:
		return Vector2.ZERO
	return global_position.direction_to(target.global_position)


func _on_health_died() -> void:
	ScoreManager.add_points(points)
	queue_free()
