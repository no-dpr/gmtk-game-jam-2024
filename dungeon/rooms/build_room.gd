class_name Room
extends Node2D

@export var floor_tile_map_layer : TileMapLayer
@export var hallway_scene : PackedScene

@export var navigation_region : NavigationRegion2D

@export var bottom_left_from_center: Vector2i
@export var bottom_right_from_center: Vector2i
@export var top_left_from_center: Vector2i
@export var top_right_from_center: Vector2i

@export var additional_room_scene : PackedScene

func _ready() -> void:
	y_sort_enabled = true
	for child : Node2D in get_children():
		child.y_sort_enabled = true
		
	if additional_room_scene == null:
		additional_room_scene = load("res://dungeon/rooms/bedroom.tscn")
		
	floor_tile_map_layer.z_index = -2
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed():
		var coords := floor_tile_map_layer.local_to_map(floor_tile_map_layer.get_local_mouse_position())
		create_new_horizontal_room(coords, additional_room_scene)
		
func initialize_room_from_hallway(
	starting_position : Vector2, 
	is_left : bool,
	bottom_entrance_pos: Vector2, 
	top_entrance_pos: Vector2,
) -> Array:
	var entrance_way := bottom_right_from_center if is_left else bottom_left_from_center
	
	global_position = starting_position
	global_position.y -= 8
	global_position.x -= 16 * entrance_way.x + 8
	
	var bottom_entrance_coords := floor_tile_map_layer.local_to_map(bottom_entrance_pos - floor_tile_map_layer.global_position)
	var top_entrance_coords := floor_tile_map_layer.local_to_map(top_entrance_pos - floor_tile_map_layer.global_position)
	var bottom_half_coords := floor_tile_map_layer.get_neighbor_cell(bottom_entrance_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE)
	var top_half_coords := floor_tile_map_layer.get_neighbor_cell(top_entrance_coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	
	var hallway_coords := [bottom_entrance_coords, bottom_half_coords, top_half_coords, top_entrance_coords]
	
	var wall_tile_data := [bottom_entrance_coords, top_entrance_coords].map(
		func(coords: Vector2i) -> TileData: return floor_tile_map_layer.get_cell_tile_data(coords)
	)
	
	for coords : Vector2i in hallway_coords:
		floor_tile_map_layer.set_cell(coords)
	
	return wall_tile_data

func create_new_horizontal_room(bottom_half_coords : Vector2i, new_room_scene : PackedScene) -> void:
	var bottom_coords := floor_tile_map_layer.get_neighbor_cell(
		bottom_half_coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE
	)
	var top_half_coords := floor_tile_map_layer.get_neighbor_cell(
		bottom_half_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE
	)
	var top_coords := floor_tile_map_layer.get_neighbor_cell(
		top_half_coords, TileSet.CELL_NEIGHBOR_TOP_SIDE
	)
	
	var hallway_coords := [bottom_coords, bottom_half_coords, top_half_coords, top_coords]
	
	if ((hallway_coords.any(
		func(coords : Vector2i) -> bool:
			return floor_tile_map_layer.get_cell_source_id(
				floor_tile_map_layer.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
			) != -1
	) and hallway_coords.any(
		func(coords : Vector2i) -> bool:
			return floor_tile_map_layer.get_cell_source_id(
				floor_tile_map_layer.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
			) != -1
	)) or hallway_coords.any(
		func(coords : Vector2i) -> bool:
			return floor_tile_map_layer.get_cell_source_id(coords) == -1 \
			or floor_tile_map_layer.get_cell_tile_data(coords).get_custom_data("build_type") != "wall"
	)):
		return
		
	print("creating hallway")
		
	
	var hallway : Hallway = hallway_scene.instantiate()
	navigation_region.add_child(hallway)
	hallway.navigation_region = navigation_region
	
	hallway.initialize_hallway(
		floor_tile_map_layer.map_to_local(bottom_half_coords) + floor_tile_map_layer.global_position,
		floor_tile_map_layer.get_cell_tile_data(top_coords),
		floor_tile_map_layer.get_cell_tile_data(bottom_coords), 
		floor_tile_map_layer.get_cell_source_id(
			floor_tile_map_layer.get_neighbor_cell(bottom_half_coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
		) == -1,
		additional_room_scene
	)
	
	for coords : Vector2i in hallway_coords:
		floor_tile_map_layer.set_cell(coords)
	
	navigation_region.bake_navigation_polygon()
