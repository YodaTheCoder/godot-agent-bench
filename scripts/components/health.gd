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
	var previous := current
	current = maxi(current - amount, 0)
	if current != previous:
		health_changed.emit(current, max_health)
	if current == 0:
		died.emit()


func heal(amount: int) -> void:
	var previous := current
	current += amount
	if current != previous:
		health_changed.emit(current, max_health)
