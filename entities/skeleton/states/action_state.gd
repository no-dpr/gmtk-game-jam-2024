extends LimboState

@export var animators : SkeletonAnimations
var actor : CharacterBody2D
## Called once, when state is initialized.
func _setup() -> void:
	actor = agent as CharacterBody2D

## Called when state is entered.
func _enter() -> void:
	actor.velocity = Vector2.ZERO
	var tool : StringName = blackboard.get_var(&"tool", &"unarmed")
	
	animators.play_animation(&"action", tool)

## Called each frame when this state is active.
func _update(_delta: float) -> void:
	if actor.velocity.length_squared() > 1:
		dispatch(&"movement_started")
	elif !blackboard.get_var(&"doing_action", false):
		dispatch(EVENT_FINISHED)
