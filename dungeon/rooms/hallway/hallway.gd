class_name Hallway
extends Node2D

@export var bottom_left_from_center: Vector2i
@export var bottom_right_from_center: Vector2i
@export var top_left_from_center: Vector2i
@export var top_right_from_center: Vector2i

@export var floor_tile_layer : TileMapLayer

@export var navigation_region : NavigationRegion2D

var inner_top_left := Vector2i(1, 7)
var inner_bottom_right := Vector2i(4, 4)
var inner_top_right := Vector2i(6, 5)
var inner_bottom_left := Vector2i(3, 6)

func initialize_hallway(
	start_position : Vector2, 
	top_wall_data: TileData, 
	bottom_wall_data: TileData, 
	is_left := true,
	room_scene : PackedScene = null
) -> void:
	
	global_position = start_position
	
	var top_pos : Vector2
	var bottom_pos : Vector2
	
	var bottom_half_coords : Vector2i
	
	if is_left:
		global_position.x -= 16 * bottom_right_from_center.x + 8
		global_position.y -= 16 * bottom_right_from_center.y - 8
		if (!top_wall_data.get_custom_data("wall_type").contains("top")):
			floor_tile_layer.set_cell(top_right_from_center, 0, inner_top_left)
			
		if (!bottom_wall_data.get_custom_data("wall_type").contains("bottom")):
			floor_tile_layer.set_cell(bottom_right_from_center, 0, inner_bottom_left)
			
		top_pos = floor_tile_layer.map_to_local(top_left_from_center)
		bottom_pos = floor_tile_layer.map_to_local(bottom_left_from_center)
		
		bottom_half_coords = floor_tile_layer.get_neighbor_cell(bottom_left_from_center, TileSet.CELL_NEIGHBOR_TOP_SIDE)
	else:
		global_position.x += 16 * bottom_right_from_center.x - 8
		global_position.y += 16 * bottom_right_from_center.y - 24
		if (!top_wall_data.get_custom_data("wall_type").contains("top")):
			floor_tile_layer.set_cell(top_left_from_center, 0, inner_top_right)
			
		if (!bottom_wall_data.get_custom_data("wall_type").contains("bottom")):
			floor_tile_layer.set_cell(bottom_left_from_center, 0, inner_bottom_right)
			
		top_pos = floor_tile_layer.map_to_local(top_right_from_center)
		bottom_pos = floor_tile_layer.map_to_local(bottom_right_from_center)
		
		bottom_half_coords = floor_tile_layer.get_neighbor_cell(bottom_right_from_center, TileSet.CELL_NEIGHBOR_TOP_SIDE)
		
	if room_scene == null: return
	
	var room : Room = room_scene.instantiate()
	navigation_region.add_child(room)
	room.navigation_region = navigation_region
	
	var tile_wall_data := room.initialize_room_from_hallway(
		floor_tile_layer.map_to_local(bottom_half_coords) + floor_tile_layer.global_position,
		is_left,
		bottom_pos + floor_tile_layer.global_position,
		top_pos + floor_tile_layer.global_position
	)
	
	if tile_wall_data.size() != 2: return

	var other_bottom_wall_data : TileData = tile_wall_data[0]
	var other_top_wall_data : TileData = tile_wall_data[1]
	if !is_left:
		if (!other_top_wall_data.get_custom_data("wall_type").contains("top")):
			floor_tile_layer.set_cell(top_right_from_center, 0, inner_top_left)
			
		if (!other_bottom_wall_data.get_custom_data("wall_type").contains("bottom")):
			floor_tile_layer.set_cell(bottom_right_from_center, 0, inner_bottom_left)
	
	else:
		if (!other_top_wall_data.get_custom_data("wall_type").contains("top")):
			floor_tile_layer.set_cell(top_left_from_center, 0, inner_top_right)
			
		if (!other_bottom_wall_data.get_custom_data("wall_type").contains("bottom")):
			floor_tile_layer.set_cell(bottom_left_from_center, 0, inner_bottom_right)
	
			
	
		
		
