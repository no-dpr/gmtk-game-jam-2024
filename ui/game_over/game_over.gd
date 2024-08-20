extends Control

@onready var description: Label = $Panel/VBoxContainer/Description
@onready var game_over_jingle: AudioStreamPlayer = $GameOverJingle


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	get_tree().paused = true
	
func _ready() -> void:
	game_over_jingle.play()
	MusicManager.stop()
	description.text = "Before you died, you slayed %2d adventurers and built %2d rooms." \
		% [Globals.adventurers_slain, Globals.rooms_created]

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ENTER:
			get_tree().paused = false
			Resources.reset_resources()
			Globals.adventurers_slain = 0
			Globals.rooms_created = 0
			get_tree().reload_current_scene()
