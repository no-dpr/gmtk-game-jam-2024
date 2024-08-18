class_name SkeletonAnimations
extends Node

@export var torso_animator : AnimationPlayer
@export var legs_animator : AnimationPlayer

func play_animation(animation: StringName, tool: StringName) -> void:
	var leg_animation := animation
	var torso_action := animation
	
	if (animation == &"action"):
		leg_animation = &"idle"
	if (animation == &"walk"):
		torso_action = &"idle"
		
	var torso_animation := tool + &"-" + torso_action
	
	legs_animator.play(leg_animation)
	torso_animator.play(torso_animation)
