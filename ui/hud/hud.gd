extends MarginContainer

@onready var wood: Label = %Wood
@onready var stone: Label = %Stone
@onready var skeletons: Label = %Skeletons
@onready var swords: Label = %Swords
@onready var hammers: Label = %Hammers
@onready var phase_label: Label = %PhaseLabel
@onready var phase_timer: Label = %PhaseTimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wood.text = str(Resources.wood_count)
	stone.text = str(Resources.stone_count)
	
	skeletons.text = str(Resources.skeleton_count)
	
	swords.text = str(Resources.sword_count)
	hammers.text = str(Resources.hammer_count)
	
	if PhaseManager.build_phase:
		phase_label.text = "Build!" 
		var time : float = PhaseManager.build_timer.time_left
		
		var seconds : int = floori(time) % 60
		var minutes : int = floori(time / 60)
		phase_timer.text = "%2d:%02d" % [minutes, seconds]
	else:
		phase_label.text = "Defend!"
		phase_timer.text = "%2d/%2d Left" % [
			PhaseManager.adventurers_alive, PhaseManager.adventurers_spawned
		]
