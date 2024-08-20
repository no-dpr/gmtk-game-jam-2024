extends NavigationRegion2D

@export var empty_chamber : Room

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NavigationGlobals.navigation_region = self
	_initialize_rooms.call_deferred()
	
func _initialize_rooms() -> void:
	empty_chamber.create_new_room(empty_chamber.right_entrance, preload("res://dungeon/rooms/mining_room.tscn"))
	await bake_finished
	empty_chamber.create_new_room(empty_chamber.left_entrance, preload("res://dungeon/rooms/bedroom.tscn"))
