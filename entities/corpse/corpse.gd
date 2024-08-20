class_name Corpse
extends Node2D

@export var sprite : Sprite2D
@export var visuals : Node2D

@export var skeleton_reanimation_scene : PackedScene

func revivify() -> void:
	var skeleton_reanimation : Node2D = skeleton_reanimation_scene.instantiate()
	add_sibling(skeleton_reanimation)
	skeleton_reanimation.global_position = global_position
	queue_free()
