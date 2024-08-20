class_name Skeleton
extends EvilGuy

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var tool : StringName :
	get:
		return hsm.blackboard.get_var(&"tool", &"unarmed")
	set(value):
		hsm.blackboard.set_var(&"tool", value)
		if (value == &"sword"):
			hitbox_component.damage = 5
		else:
			hitbox_component.damage = 1

func _ready() -> void:
	super()
	Resources.skeleton_count += 1
	
func _process(delta: float) -> void:	
	super(delta)
	hitbox_component.scale.x = sprite.scale.x
	
func die() -> void:
	Resources.skeleton_count -= 1
	queue_free()
