class_name ActionComponent
extends Area2D

signal resource_collected

@export_enum("stone", "wood", "sword", "hammer") var resource : String
@export var count := 1

@export_group("Times")
@export var normal_time : float = 5
@export var hammer_time : float = 2

@export_group("Cost")
@export var stone_cost := 0
@export var wood_cost := 0

var timers : Dictionary = Dictionary()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Skeleton:
		body.hsm.start_action()
		
		var time := hammer_time if body.tool == &"hammer" else normal_time
		
		var timer := Timer.new()
		add_child(timer)
		timer.name = body.name + " Timer"
		timer.one_shot = false
		timer.timeout.connect(_on_timer_timeout)
		timers[body] = timer
		
		timer.start(time)
		
func _on_body_exited(body: Node2D) -> void:
	if timers.has(body):
		if body is Skeleton: body.hsm.end_action()
		var timer : Timer = timers[body]
		timer.queue_free()
		timers.erase(body)

func _on_timer_timeout() -> void:
		if (Resources.wood_count < wood_cost or Resources.stone_count < stone_cost): return
		
		Resources.wood_count -= wood_cost
		Resources.stone_count -= stone_cost
		
		var resource_count : int = Resources.get(resource + "_count")
		Resources.set(resource + "_count", resource_count + count)
		
		resource_collected.emit()
	
