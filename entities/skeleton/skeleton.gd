class_name EvilGuy
extends CharacterBody2D

@export var sprite: Node2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent

var map_changed := false;
var selected := false;

var speed : float = 60

var target_pos : Vector2:
	get:
		return navigation_agent.target_position
	set(value):
		navigation_agent.target_position = value
		

func _ready() -> void:	
	target_pos = global_position
	NavigationServer2D.map_changed.connect(on_map_changed)
	
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	
func _physics_process(_delta: float) -> void:
	if !map_changed: return
	
	var unsafe_velocity : Vector2
	if navigation_agent.is_navigation_finished() or !navigation_agent.is_target_reachable(): 
		unsafe_velocity = Vector2.ZERO
	else:
		var target_pos := navigation_agent.get_next_path_position()
		unsafe_velocity = global_position.direction_to(target_pos) * speed
		
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = unsafe_velocity
	else:
		_on_velocity_computed(unsafe_velocity)
	move_and_slide()
		
func _process(_delta: float) -> void:
	if (velocity.x != 0):
		sprite.scale.x = sign(velocity.x) * abs(sprite.scale.x)
		
	var material := sprite.material as ShaderMaterial
	material.set_shader_parameter("enabled", selected)
	
func _on_velocity_computed(safe_velocity : Vector2) -> void:
	velocity = safe_velocity
			
func on_map_changed(_map : RID) -> void:
	map_changed = true
			
