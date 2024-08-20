extends NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NavigationGlobals.navigation_region = self
