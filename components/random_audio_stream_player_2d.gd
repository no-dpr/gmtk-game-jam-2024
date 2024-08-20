class_name RandomAudioStreamPlayer2D
extends AudioStreamPlayer2D

@export var min_volume_db := -1
@export var max_volume_db := 1

@export var random_pitch := false
@export var min_pitch := 0.9
@export var max_pitch := 1.1

func play_random() -> void:
	volume_db = randf_range(min_volume_db, max_volume_db)
	
	if random_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch)
		
	play()
	
