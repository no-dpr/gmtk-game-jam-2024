extends LimboState

@export var animator : AnimationPlayer
var actor : EvilGuy

## Called once, when state is initialized.
func _setup() -> void:
	actor = agent as EvilGuy
	

## Called when state is entered.
func _enter() -> void:
	animator.play(&"revive")

## Called when state is exited.
func _exit() -> void:
	pass

## Called each frame when this state is active.
func _update(_delta: float) -> void:
	if actor.velocity.length_squared() > 1:
		dispatch(&"movement_started")
	elif !blackboard.get_var(&"reviving", false):
		dispatch(EVENT_FINISHED)
