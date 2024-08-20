class_name Necromancer
extends EvilGuy

func die() -> void:
	get_tree().create_timer(5).timeout.connect(
		func() -> void: get_tree().quit()
	)
