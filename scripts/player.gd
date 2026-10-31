class_name Player
extends CharacterBody2D

@export var speed := 200.0

@onready var weapon: Weapon = $Weapon


static func compute_velocity(input: Vector2, speed: float) -> Vector2:
	return input.normalized() * speed


func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = compute_velocity(input, speed)
	move_and_slide()
	if Input.is_action_pressed("ui_accept"):
		weapon.try_fire(Time.get_ticks_msec() / 1000.0)
