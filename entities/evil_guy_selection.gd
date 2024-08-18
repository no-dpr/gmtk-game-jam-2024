extends Node2D

@export var debug: bool = false
var dragging := false
var selected := []
var drag_start := Vector2.ZERO
var select_rect := RectangleShape2D.new()
var select_start := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if selected.size() > 0: 
				for entity : EvilGuy in selected:
					entity.target_pos = get_global_mouse_position()
					entity.selected = false
				selected = []
				return
				
			
			dragging = true
			drag_start = get_global_mouse_position()
			
		elif dragging:
			dragging = false
			queue_redraw()
			
			var drag_end := get_global_mouse_position()
			select_rect.size = (drag_end - drag_start).abs()
			select_start = (drag_start + drag_end) / 2
			
			var space := get_world_2d().direct_space_state
			var query := PhysicsShapeQueryParameters2D.new()
			
			query.shape = select_rect
			query.transform = Transform2D(0, select_start)
			
			selected = space.intersect_shape(query) \
				.map(func (item : Dictionary) -> Object: return item.collider) \
				.filter(func (object : Object) -> bool: return object is EvilGuy)
				
			for entity : EvilGuy in selected:
				entity.selected = true
			
	elif event is InputEventMouseMotion and dragging:
		queue_redraw()
		
	get_viewport().set_input_as_handled()
			
func _draw() -> void:
	if !dragging: return
	
	draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start), Color(0.3, 0.6, 1, 0.2))
	
	
