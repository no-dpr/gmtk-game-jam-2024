class_name BuildMenu
extends MarginContainer

signal selected(room_scene: PackedScene, price: int)

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	get_tree().paused = true
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_ENTER: 
			queue_free()
		
func select(room_scene: PackedScene, price: int) -> void:
	if Resources.stone_count < price:
		return
	
	selected.emit(room_scene, price)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _exit_tree() -> void:
	get_tree().paused = false
