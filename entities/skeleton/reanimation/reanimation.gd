class_name Reanimation
extends Node2D

@export var sprite : Sprite2D
@export var skeleton_scene : PackedScene

func spawn_skeleton() -> void:
	var skeleton : Skeleton = skeleton_scene.instantiate()
	add_sibling(skeleton)
	skeleton.global_position = global_position
	
	NavigationGlobals.navigation_region.bake_navigation_polygon()
	
	queue_free()
