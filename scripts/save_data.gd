class_name SaveData
extends Resource

@export var score: int = 0
@export var player_health: int = 0
## Reserved for item counts (item id -> count). Not used until the game has an inventory.
@export var inventory: Dictionary = {}
