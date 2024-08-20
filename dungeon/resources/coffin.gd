extends Node2D

@export var skeleton_scene : PackedScene
@export var action_component : ActionComponent
@export var skeleton_spawn : Marker2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action_component.resource_collected.connect(_on_resource_collected.call_deferred)



func _on_resource_collected() -> void:
	var skeleton : Skeleton = skeleton_scene.instantiate()
	
	var entities_node := get_tree().get_first_node_in_group(&"entities")
	entities_node.add_child(skeleton)
	skeleton.global_position = skeleton_spawn.global_position
	
	skeleton.target_pos = skeleton.global_position
	
	NavigationGlobals.navigation_region.bake_navigation_polygon()
	
