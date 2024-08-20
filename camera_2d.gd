extends Camera2D


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.is_pressed()):
		if event.keycode == KEY_EQUAL:
			zoom *= 2
			zoom = zoom.min(Vector2.ONE * 8)
		elif event.keycode == KEY_MINUS:
			zoom *= 0.5
			zoom = zoom.max(Vector2.ONE / 2)
