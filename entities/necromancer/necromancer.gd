class_name Necromancer
extends EvilGuy

@export var game_over_scene : PackedScene

func die() -> void:
	var game_over : Control= game_over_scene.instantiate()
	Globals.ui.add_child(game_over)
