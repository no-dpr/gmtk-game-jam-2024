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
				var target_pos := get_global_mouse_position()
			
				var space := get_world_2d().direct_space_state
				var query := PhysicsPointQueryParameters2D.new()
				
				query.position = get_global_mouse_position()
				query.collide_with_areas = true
				query.collide_with_bodies = false
				
				var intersections := space.intersect_point(query, 1)
				if intersections.size() == 1:
					var intersection : Dictionary = intersections[0]
					var area : Node2D = intersection.collider
					if area is InteractableComponent:
						target_pos = area.target.global_position
					
				for item : SelectionComponent in selected:
					item.actor.target_pos = target_pos
					item.selected = false
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
			query.collide_with_areas = true
			query.collide_with_bodies = false
			
			selected = space.intersect_shape(query) \
				.map(func (item : Dictionary) -> Object: return item.collider) \
				.filter(func (object : Object) -> bool: return object is SelectionComponent)
				
			for item : SelectionComponent in selected:
				item.selected = true
			
	elif event is InputEventMouseMotion and dragging:
		queue_redraw()
		
	get_viewport().set_input_as_handled()
			
func _draw() -> void:
	if !dragging: return
	
	draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start), Color(0.3, 0.6, 1, 0.2))
	
	
