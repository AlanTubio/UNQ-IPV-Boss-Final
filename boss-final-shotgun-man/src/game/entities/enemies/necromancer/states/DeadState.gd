extends NecromancerState


func enter() -> void:
	character.dead = true
	character.collision_layer = 0
	character.collision_mask = 0
	character._play_animation(&"die")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name in [&"die"]:
		character._remove()


func update(_delta: float) -> void:
	return


func exit() -> void:
	return


func handle_input(_event: InputEvent) -> void:
	return
