class_name EvilGuy
extends CharacterBody2D

@export var id: StringName = &"skeleton"
@export var sprite: Node2D

@export var hsm: LimboHSM
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var health_component: HealthComponent = $HealthComponent


var map_changed := false

var speed : float = 60

var target : Node2D:
	get:
		return _target
	set(value):
		if _target != null:
			prev_target = _target
		_target = value

var _target : Node2D = null
var prev_target : Node2D = null

var is_targetting_node := false
var target_pos : Vector2:
	get:
		return navigation_agent.target_position
	set(value):
		navigation_agent.target_position = value
		
var go_back_to_prev_target := false

func _ready() -> void:		
	target_pos = global_position
	NavigationServer2D.map_changed.connect(on_map_changed)
	
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	health_component.died.connect(func() -> void: hsm.dispatch(&"die"))
	
func _physics_process(_delta: float) -> void:
	if !map_changed: return
	
	if not is_instance_valid(target):
		target = null
		
	if target != null and is_targetting_node:
		target_pos = target.global_position
	
	
	var unsafe_velocity : Vector2
	if navigation_agent.is_navigation_finished():
		unsafe_velocity = Vector2.ZERO
		if target == null and prev_target != null and is_instance_valid(prev_target):
			if go_back_to_prev_target:
				is_targetting_node = true
				target = prev_target 
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
	if target != null:
		var direction : int = sign(global_position.direction_to(target.global_position).x)
		sprite.scale.x = direction * abs(sprite.scale.x) if direction != 0 else sprite.scale.x
	
func _on_velocity_computed(safe_velocity : Vector2) -> void:
	velocity = safe_velocity
			
func on_map_changed(_map : RID) -> void:
	map_changed = true
			
