class_name Enemy
extends CharacterBody2D

@export var points := 10
@export var speed := 80.0
@export var target: Node2D

@onready var health: Health = $Health


def _ready() -> void:
	health.died.connect(_on_health_died)


def _physics_process(_delta: float) -> void:
	velocity = direction_to_target() * speed
	move_and_slide()


def direction_to_target() -> Vector2:
	if target == null:
		return Vector2.ZERO
	return global_position.direction_to(target.global_position)


def _on_health_died() -> void:
	Events.enemy_died.emit(points)
	queue_free()
