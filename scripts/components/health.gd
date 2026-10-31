class_name Health
extends Node

signal died

@export var max_health := 100

var current: int


func _ready() -> void:
	current = max_health


func damage(amount: int) -> void:
	if current == 0:
		return
	current = maxi(current - amount, 0)
	if current == 0:
		died.emit()


func heal(amount: int) -> void:
	current += amount
