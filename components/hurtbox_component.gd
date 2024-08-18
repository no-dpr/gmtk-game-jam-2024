class_name HurtboxComponent
extends Area2D

signal hurt(hitbox : HitboxComponent)

@export var health_component : HealthComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(on_hitbox_entered) # Replace with function body.
	
func on_hitbox_entered(hitbox: Area2D) -> void:
	if hitbox is HitboxComponent:
		health_component.damage(hitbox.damage)
		hitbox.hit_hurtbox.emit(self)
		hurt.emit(hitbox)
