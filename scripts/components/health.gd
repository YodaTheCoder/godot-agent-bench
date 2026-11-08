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
	var old_current := current
	current = maxi(current - amount, 0)
	if current < old_current:
		damaged.emit(old_current - current, current)
	if current == 0:
		died.emit()


func heal(amount: int) -> void:
	current += amount
