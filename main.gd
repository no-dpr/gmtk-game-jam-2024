extends Node2D

@onready var calm_music: AudioStreamPlayer = %CalmMusic
@onready var battle_music_intro: AudioStreamPlayer = %BattleMusicIntro
@onready var battle_music: AudioStreamPlayer = %BattleMusic

func _ready() -> void:
	MusicManager.calm_music = calm_music
	MusicManager.battle_music_intro = battle_music_intro
	MusicManager.battle_music = battle_music
	MusicManager.start()
	PhaseManager.start_build_phase()
	
