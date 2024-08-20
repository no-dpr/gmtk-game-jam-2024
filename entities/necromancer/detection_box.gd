extends Area2D

@export var hsm : NecromancerHSM

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area : Area2D) -> void:
	if area is ReviveBox:
		hsm.start_reviving()
		
