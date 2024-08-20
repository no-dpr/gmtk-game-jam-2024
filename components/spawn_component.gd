class_name SpawnComponent
extends Marker2D

@export var knight_scene: PackedScene
@export var rogue_scene: PackedScene
@export var wizard_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PhaseManager.spawners.append(self)

func spawn() -> void:
	var scene : PackedScene = null
	var random := randf()
	
	if random < 0.1: scene = wizard_scene
	elif random < 0.5: scene = knight_scene
	else: scene = rogue_scene
	
	var adventurer : Adventurer = scene.instantiate()
	
	get_tree().get_first_node_in_group("entities").add_child(adventurer)
	adventurer.global_position = global_position
