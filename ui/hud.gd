extends MarginContainer

@onready var wood: Label = %Wood
@onready var stone: Label = %Stone
@onready var adventurers: Label = %Adventurers
@onready var skeletons: Label = %Skeletons
@onready var swords: Label = %Swords
@onready var hammers: Label = %Hammers
@onready var phase_label: Label = %PhaseLabel
@onready var phase_timer: Label = %PhaseTimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wood.text = "Wood: " + str(Resources.wood_count)
	stone.text = "Stone: " + str(Resources.stone_count)
	
	skeletons.text = "Skeletons: " + str(Resources.skeleton_count)
	
	swords.text = "Swords: " + str(Resources.sword_count)
	hammers.text = "Hammers: " + str(Resources.hammer_count)
