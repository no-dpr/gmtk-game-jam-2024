@tool

class_name HealthComponent
extends Node

signal health_changed(health_update : HealthUpdate)
signal died

@export var max_health : float = 1:
	get: return _max_health
	set(value): 
		_max_health = value
		if (current_health > _max_health):
			current_health = _max_health


var _max_health : float

var _current_health : float

var current_health : float:
	get: return _current_health
	set(value): 
		var previous_health := _current_health
		_current_health = clampf(value, 0, max_health)
		var health_update := HealthUpdate.new(previous_health, _current_health, max_health)
		health_changed.emit(health_update)
		if not has_health_remaining and not _has_died:
			_has_died = true
			died.emit()
		
		
var has_health_remaining : bool:
	get: return current_health > 0
	
var _has_died := false
		
func _ready() -> void:
	_initialize_health.call_deferred()
	
func damage(amount : float):
	current_health -= amount
	
func heal(amount : float):
	current_health += amount
	
func set_max_health(health : float):
	max_health = health
	
func _initialize_health() -> void:
	current_health = max_health

class HealthUpdate extends RefCounted:
	func _init(previous_health : float, current_health : float, max_health : float) -> void:
		self.previous_health = previous_health
		self.current_health = current_health
		self.max_health = max_health
		self.health_percent = current_health / max_health if max_health > 0 else 0.0
		self.is_heal = current_health >= previous_health
