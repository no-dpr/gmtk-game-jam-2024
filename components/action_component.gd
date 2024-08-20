class_name ActionComponent
extends Area2D

signal resource_collected

@export_enum("stone", "wood", "sword", "hammer") var resource : String
@export var count := 1

@export_group("Times")
@export var use_timers : bool = true
@export var normal_time : float = 5
@export var hammer_time : float = 2

@export_group("Cost")
@export var stone_cost := 0
@export var wood_cost := 0

@export_group("Dependencies")
@export var target_if_seen : bool = false
@export var interactable : InteractableComponent

var timers : Dictionary = Dictionary()
var original_targets : Dictionary = Dictionary()

var active_bodies : Array[Skeleton] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _physics_process(_delta: float) -> void:
	for body in active_bodies:
		var look_direction : int = sign(body.sprite.scale.x)
		var direction_to_target : int = sign(body.global_position.direction_to(global_position).x)
			
func _activate_action(body: Skeleton) -> void:
	body.hsm.start_action()
	
	if !use_timers: return
	
	var time := hammer_time if body.tool == &"hammer" else normal_time
	
	var timer := Timer.new()
	add_child(timer)
	timer.name = body.name + " Timer"
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	timers[body] = timer
	
	timer.start(time)
	
func _deactivate_action(body: Skeleton) -> void:
	if target_if_seen and interactable != null:
		body.go_back_to_prev_target = false
		body.target = null
		if original_targets.has(body):
			body.is_targetting_node = false
			body.target = original_targets[body]
		original_targets.erase(body)
			
	body.hsm.end_action()
				
	if timers.has(body):
		var timer : Timer = timers[body]
		timer.queue_free()
		timers.erase(body)
	

func _on_body_entered(body: Node2D) -> void:
	if body is Skeleton:
		
		if target_if_seen and interactable != null: 
			body.go_back_to_prev_target = true
			original_targets[body] = body.target
			body.target = interactable.target
			body.is_targetting_node = true
		active_bodies.append(body)
		_activate_action(body)
		
		
func _on_body_exited(body: Node2D) -> void:
	if body is Skeleton: 
		active_bodies.erase(body)
		_deactivate_action(body)

func _on_timer_timeout() -> void:
		if (Resources.wood_count < wood_cost or Resources.stone_count < stone_cost): return
		
		Resources.wood_count -= wood_cost
		Resources.stone_count -= stone_cost
		
		var resource_count : int = Resources.get(resource + "_count")
		Resources.set(resource + "_count", resource_count + count)
		
		resource_collected.emit()
		

	
