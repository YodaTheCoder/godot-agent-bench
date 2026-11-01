@warning_ignore("unused_signal")
signal enemy_died(points: int)

# This autoload serves as a global event bus. It emits signals which other
# autoloads and nodes can listen to. It must not have a class_name.
