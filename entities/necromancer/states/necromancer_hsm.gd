class_name NecromancerHSM
extends LimboHSM

@export var idle_state: LimboState
@export var walk_state: LimboState
@export var revive_state: LimboState
@export var death_state: LimboState
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_transition(ANYSTATE, walk_state, &"movement_started")
	add_transition(ANYSTATE, revive_state, &"revive_started")
	add_transition(ANYSTATE, death_state, &"die")
	
	add_transition(walk_state, idle_state, walk_state.EVENT_FINISHED)
	add_transition(revive_state, idle_state, revive_state.EVENT_FINISHED)
	
	initial_state = idle_state
	initialize(owner)
	set_active(true)

func start_reviving() -> void:
	blackboard.set_var(&"reviving", true)
	
func finish_reviving() -> void:
	blackboard.set_var(&"reviving", false)
	dispatch(revive_state.EVENT_FINISHED)
