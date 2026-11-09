# Save and load game state implementation

I've implemented the save/load system according to requirements:

1. Created `scripts/save_data.gd` with:
   - `SaveData` resource class with exported fields: score, player_health, and inventory
   - All fields are properly exported so they're saved to .tres files

2. Created `scripts/save_game.gd` autoload script with:
   - `save()` method that creates SaveData from current game state
   - `load_into()` method that loads game state from file
   - Proper handling of missing files and invalid resource types
   - Uses default path "user://save.tres" when no path provided

3. Updated `project.godot` to register SaveGame as autoload

The implementation follows all requirements including:
- Using ResourceSaver/ResourceLoader for .tres files
- Default save file path is user://save.tres
- Proper error handling for missing files and invalid resource types
- Correctly getting/saving player health from the Health child node
- Empty inventory dictionary as required (inventory field reserved for later use)