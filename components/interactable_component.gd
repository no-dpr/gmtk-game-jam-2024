class_name InteractableComponent
extends Area2D

@export var sprite: Node2D
@export var outline_material: Material

@export var target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	input_pickable = true

	
	mouse_entered.connect(set_outline)
	mouse_exited.connect(remove_outline)
	input_event.connect(
		func(viewport: Node, event : InputEvent, _shape: int) -> void:
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
				remove_outline()
	)

func set_outline() -> void:

	sprite.material = outline_material
	
func remove_outline() -> void:

	sprite.material = null
