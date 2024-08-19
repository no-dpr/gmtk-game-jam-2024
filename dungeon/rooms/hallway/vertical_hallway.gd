class_name VerticalHallway
extends Hallway

func initialize_hallway(
	start_position : Vector2, 
	right_wall_data: TileData, 
	left_wall_data: TileData, 
	is_negative := true,
	room_scene : PackedScene = null
) -> void:
	
	global_position = start_position
	
	var right_pos : Vector2
	var left_pos : Vector2
	
	var left_half_coords : Vector2i
	
	if is_negative:
		global_position.x -= 16 * bottom_right_from_center.x - 24 
		global_position.y -= 16 * bottom_right_from_center.y - 56
		if (!right_wall_data.get_custom_data("wall_type").contains("right")):
			floor_tile_layer.set_cell(top_right_from_center, 0, inner_bottom_right)
			
		if (!left_wall_data.get_custom_data("wall_type").contains("botlefttom")):
			floor_tile_layer.set_cell(top_left_from_center, 0, inner_bottom_left)
			
		right_pos = floor_tile_layer.map_to_local(bottom_right_from_center)
		left_pos = floor_tile_layer.map_to_local(bottom_left_from_center)
		
		left_half_coords = floor_tile_layer.get_neighbor_cell(bottom_left_from_center, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
	else:
		global_position.x += 16 * bottom_right_from_center.x - 8
		global_position.y += 16 * bottom_right_from_center.y - 40
		if (!right_wall_data.get_custom_data("wall_type").contains("right")):
			floor_tile_layer.set_cell(bottom_right_from_center, 0, inner_top_right)
			
		if (!left_wall_data.get_custom_data("wall_type").contains("left")):
			floor_tile_layer.set_cell(bottom_left_from_center, 0, inner_top_left)
			
		right_pos = floor_tile_layer.map_to_local(top_right_from_center)
		left_pos = floor_tile_layer.map_to_local(top_left_from_center)
		
		left_half_coords = floor_tile_layer.get_neighbor_cell(top_left_from_center, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
		
	if room_scene == null: return
	
	var room : Room = room_scene.instantiate()
	navigation_region.add_child(room)
	room.navigation_region = navigation_region
	
	var tile_wall_data := room.initialize_room_from_vertical_hallway(
		floor_tile_layer.map_to_local(left_half_coords) + floor_tile_layer.global_position,
		is_negative,
		left_pos + floor_tile_layer.global_position,
		right_pos + floor_tile_layer.global_position
	)
	
	if tile_wall_data.size() != 2: return

	var other_left_wall_data : TileData = tile_wall_data[0]
	var other_right_wall_data : TileData = tile_wall_data[1]
	if !is_negative:
		if (!other_right_wall_data.get_custom_data("wall_type").contains("right")):
			floor_tile_layer.set_cell(top_right_from_center, 0, inner_bottom_right)
			
		if (!other_left_wall_data.get_custom_data("wall_type").contains("left")):
			floor_tile_layer.set_cell(top_left_from_center, 0, inner_bottom_left)
	
	else:
		if (!other_right_wall_data.get_custom_data("wall_type").contains("right")):
			floor_tile_layer.set_cell(bottom_right_from_center, 0, inner_top_right)
			
		if (!other_left_wall_data.get_custom_data("wall_type").contains("left")):
			floor_tile_layer.set_cell(bottom_left_from_center, 0, inner_top_left)
	
			
	
		
		
