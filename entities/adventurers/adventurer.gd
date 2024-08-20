class_name Adventurer
extends CharacterBody2D

@export var sprite: Node2D
@export var hsm : LimboHSM

@export_group("Corpse Info")
@export var corpse_scene : PackedScene = preload("res://entities/corpse/corpse.tscn")
@export var death_sprite : Sprite2D 
@export var death_sprite_frame : int = 7

@onready var navigation_agent := $NavigationAgent2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var detection_area: Area2D = $DetectionArea
@onready var hitbox_component: HitboxComponent = $HitboxComponent


var map_changed := false

var speed : float = 60

var target : Node2D = null

func _ready() -> void:	
	NavigationServer2D.map_changed.connect(on_map_changed)
	PhaseManager.adventurers_alive += 1
	PhaseManager.adventurers_spawned += 1
	
	health_component.died.connect(func() -> void: hsm.dispatch(&"die"))
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	
func _physics_process(_delta: float) -> void:
	
	if (target == null or not is_instance_valid(target)):
		var evil_guys := get_tree().get_nodes_in_group(&"evil_guys")
		if evil_guys.size() > 0:
			evil_guys.sort_custom(
				func(entity1 : Node2D, entity2: Node2D) -> bool:
					navigation_agent.target_position = entity1.global_position
					var distance1 : float = navigation_agent.distance_to_target()
					
					navigation_agent.target_position = entity2.global_position
					var distance2 : float = navigation_agent.distance_to_target()
					
					return distance1 < distance2
			)

			target = evil_guys[0]
		
	if !map_changed: return
	
	if target != null and is_instance_valid(target):
		navigation_agent.target_position = target.global_position
	
	var unsafe_velocity : Vector2
	if navigation_agent.is_navigation_finished() or !navigation_agent.is_target_reachable(): 
		unsafe_velocity = Vector2.ZERO
	else:
		var target_pos : Vector2= navigation_agent.get_next_path_position()
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
	hitbox_component.scale.x = sign(sprite.scale.x)
func _on_velocity_computed(safe_velocity : Vector2) -> void:
	velocity = safe_velocity

func _on_body_entered(body: Node2D) -> void:
	if target != null and target == body:
		hsm.blackboard.set_var(&"attacking", true)
		
func _on_body_exited(body: Node2D) -> void:
	if target != null and target == body:
		hsm.blackboard.set_var(&"attacking", false)
			
func on_map_changed(_map : RID) -> void:
	map_changed = true
			
func die() -> void:
	PhaseManager.adventurers_alive -= 1
	
	var corpse : Corpse = corpse_scene.instantiate()
	add_sibling(corpse)
	
	corpse.global_position = global_position
	corpse.visuals.position = sprite.position
	corpse.visuals.scale = sprite.scale
	
	corpse.sprite.texture = death_sprite.texture
	corpse.sprite.hframes = death_sprite.hframes
	corpse.sprite.vframes = death_sprite.vframes
	corpse.sprite.frame = death_sprite_frame
	
	queue_free()
