extends PanelContainer

@export var room_scene : PackedScene
@export var room_name : StringName
@export var room_icon : Texture2D
@export var room_price : int = 10

@export var build_menu : BuildMenu

@onready var room_icon_rect: TextureRect = %RoomIcon
@onready var room_name_label: Label = %RoomName
@onready var room_price_label: Label = %RoomCost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_name_label.text = room_name
	room_price_label.text = str(room_price)
	room_icon_rect.texture = room_icon
	
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	resized.connect(func() -> void: pivot_offset = size / 2)
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			select()
	
func select() -> void:
	print(room_name)
	build_menu.select(room_scene, room_price)

func _on_mouse_entered() -> void:
	scale = Vector2.ONE * 1.05
	
func _on_mouse_exited() -> void:
	scale = Vector2.ONE
	
