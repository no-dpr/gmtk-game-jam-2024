class_name SelectionComponent
extends Area2D

@export var outline_material : Material

@export var actor: EvilGuy
@export var sprite: Node2D

var selected := false

func _process(delta: float) -> void:
	
	if selected:
		sprite.material = outline_material
	else:
		sprite.material = null
