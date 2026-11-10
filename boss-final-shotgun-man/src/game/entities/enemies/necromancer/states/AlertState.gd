extends NecromancerState


func enter() -> void:
	character.velocity = Vector2.ZERO
	fire()


func exit() -> void:
	return


func update(_delta: float) -> void:
	character._look_at_target()


func fire() -> void:
	character._fire()
	character._play_animation(&"attack")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"hurt":
		_restore_animation_after_hurt()
		return
	if character.target == null:
		finished.emit(&"idle")
	else:
		match anim_name:
			&"attack":
				character._play_animation(&"alert")
			&"alert":
				if character._can_see_target():
					fire()
				else:
					finished.emit(&"idle")


func _handle_body_exited(body: Node) -> void:
	super._handle_body_exited(body)
	if character.target == null:
		if character.get_current_animation() != &"attack":
			finished.emit(&"idle")


func handle_input(_event: InputEvent) -> void:
	return
