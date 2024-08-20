extends Node

var calm_music: AudioStreamPlayer
var battle_music_intro: AudioStreamPlayer
var battle_music: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PhaseManager.phase_changed.connect(_on_phase_changed)

func _on_phase_changed(build_phase : bool) -> void:
	if build_phase:
		battle_music.stop()
		battle_music_intro.stop()
		
		calm_music.play()
	else:
		calm_music.stop()
		battle_music_intro.finished.connect(battle_music.play)
		battle_music_intro.play()
		
func stop() -> void:
	calm_music.stop()
	battle_music.stop()
	battle_music_intro.stop()
	
func start() -> void:
	calm_music.play()
