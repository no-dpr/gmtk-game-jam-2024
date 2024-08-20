extends LimboState

@export var animators : SkeletonAnimations
var actor : CharacterBody2D
## Called once, when state is initialized.
func _setup() -> void:
	actor = agent as CharacterBody2D

## Called when state is entered.
func _enter() -> void:
	actor.velocity = Vector2.ZERO
	actor.set_physics_process(false)
	
	animators.play_death()
	

## Called when state is exited.
func _exit() -> void:
	pass
