extends LimboState

@export var animator : AnimationPlayer
var actor : Adventurer
## Called once, when state is initialized.
func _setup() -> void:
	actor = agent as Adventurer

## Called when state is entered.
func _enter() -> void:
	actor.velocity = Vector2.ZERO
	actor.set_physics_process(false)
	
	animator.play(&"death")

## Called when state is exited.
func _exit() -> void:
	pass
