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
	_start_position : Vector2, 
	_positive_wall_data: TileData, 
	_negative_wall_data: TileData, 
	_is_negative := false,
	_room_scene : PackedScene = null
) -> void:
	pass