class_name CollectionComponent
extends Area2D

@export_enum("sword", "hammer") var tool : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if Resources.get(tool + &"_count") <= 0: return
	
	if body is Skeleton:
		var current_tool : StringName = body.tool
		if current_tool != &"unarmed":
			var current_tool_count : int = Resources.get(current_tool + &"_count") 
			Resources.set(current_tool + &"_count", current_tool_count + 1) 
			
		body.tool = tool
		var tool_count : int = Resources.get(tool + &"_count") 
		Resources.set(tool + &"_count", tool_count - 1) 
		
