extends LimboState

@export 
var actor : CharacterBody2D
## Called once, when state is initialized.
func _setup() -> void:
	actor = agent as CharacterBody2D

## Called when state is entered.
func _enter() -> void:
	actor.velocity = Vector2.ZERO
	

## Called when state is exited.
func _exit() -> void:
	pass

## Called each frame when this state is active.
func _update(delta: float) -> void:
	pass
