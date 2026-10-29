extends OrcShamanState

func enter() -> void:
	# Seteamos todas las variables de muerte para que no joda
	character._play_animation(&"dead")
	character.dead = true
	character.collision_layer = 0
	character.collision_mask = 0
	
	# Y determinamos qué animación de muerte usar
	character._play_animation(&"die")


# Y al terminar cualquier animación de muerte, triggereamos "_remove"
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name in [&"die"]:
		character._remove()


func update(_delta: float) -> void:
	return


func exit() -> void:
	return


func handle_input(_event: InputEvent) -> void:
	return
