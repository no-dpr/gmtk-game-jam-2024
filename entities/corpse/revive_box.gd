class_name ReviveBox
extends Area2D

@export var corpse : Corpse
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area : Area2D) -> void:
	if area is RevivifyBox:
		corpse.revivify()
