class_name SkeletonHSM
extends LimboHSM

@export var idle_state: LimboState
@export var move_state: LimboState
@export var action_state: LimboState
@export var death_state: LimboState

const MOVEMENT_STARTED = &"movement_started"
const ACTION_STARTED = &"action_started"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_transition(ANYSTATE, move_state, MOVEMENT_STARTED)
	add_transition(ANYSTATE, action_state, ACTION_STARTED)
	add_transition(ANYSTATE, death_state, &"die")
	
	add_transition(move_state, idle_state, move_state.EVENT_FINISHED)
	add_transition(action_state, idle_state, action_state.EVENT_FINISHED)
	initial_state = idle_state
	
	initialize(owner)
	set_active(true)
	
	
func start_action() -> void:
	blackboard.set_var(&"doing_action", true)
	
func end_action() -> void:
	blackboard.set_var(&"doing_action", false)
	dispatch(action_state.EVENT_FINISHED)
	
