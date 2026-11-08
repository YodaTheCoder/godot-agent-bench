class_name Health
extends Node

signal died
signal damaged(amount: int, remaining: int)

@export var max_health := 100

var current: int = max_health


func _ready() -> void:
	current = max_health


func damage(amount: int) -> void:
	if current == 0:
		return
	var health_loss := maxi(current - amount, 0)
	if health_loss == 0:
		return
	var remaining := current - health_loss
	current = remaining
	damaged.emit(health_loss, remaining)
	if remaining == 0:
		died.emit()


func heal(amount: int) -> void:
	current += amount
