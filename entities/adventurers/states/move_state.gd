extends LimboState

@export var animator : AnimationPlayer
var actor : Adventurer
## Called once, when state is initialized.
func _setup() -> void:
	actor = agent as Adventurer

## Called when state is entered.
func _enter() -> void:
	animator.play(&"walk")

## Called when state is exited.
func _exit() -> void:
	pass

## Called each frame when this state is active.
func _update(_delta: float) -> void:
	if actor.velocity.length_squared() < 1:
		dispatch(
			&"attack_started" if blackboard.get_var(&"attacking", false) else EVENT_FINISHED
		)
