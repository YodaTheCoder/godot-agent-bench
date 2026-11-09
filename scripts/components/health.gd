class_name Health
extends Node

signal died
signal health_changed(current: int, max_health: int)

@export var max_health := 100

var current: int = max_health


func _ready() -> void:
	current = max_health


func damage(amount: int) -> void:
	if current == 0:
		return
	current = maxi(current - amount, 0)
	if current == 0:
		died.emit()
	else:
		health_changed.emit(current, max_health)


func heal(amount: int) -> void:
	var old_current = current
	current += amount
	if current > max_health:
		current = max_health
	if current != old_current:
		health_changed.emit(current, max_health)
