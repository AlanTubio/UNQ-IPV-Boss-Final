extends NecromancerState

var _was_target_in_air: bool = false


func enter() -> void:
	character.velocity = Vector2.ZERO
	_was_target_in_air = not character._is_target_on_floor() if character.target else false
	fire()


func exit() -> void:
	return


func update(_delta: float) -> void:
	character._look_at_target()
	
	if character.target:
		var is_on_floor: bool = character._is_target_on_floor()
		
		# Apenas el jugador toca el piso:
		if _was_target_in_air and is_on_floor:
			_check_instant_ground_reaction()
		
		_was_target_in_air = not is_on_floor


## Si el jugador acaba de tocar el suelo y el boss está en alerta o entre ataques,
## reacciona instantáneamente lanzando el tornado
func _check_instant_ground_reaction() -> void:
	var current_anim: StringName = character.get_current_animation()
	if current_anim in [&"alert", &"idle_alert", &"idle", &"walk", &"walk_alert"] and character.can_cast_tornado():
		character.start_tornado_attack()


func fire() -> void:
	var anim: StringName = character.prepare_next_attack()
	character._play_animation(anim)


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"hurt":
		_restore_animation_after_hurt()
		return
	if character.target == null:
		finished.emit(&"idle")
	else:
		match anim_name:
			&"attack", &"attack_tornado", &"attack_implosion":
				character._play_animation(&"alert")
			&"alert":
				if character._can_see_target():
					fire()
				else:
					finished.emit(&"idle")


func _handle_body_exited(body: Node) -> void:
	super._handle_body_exited(body)
	if character.target == null:
		var current_anim: StringName = character.get_current_animation()
		if current_anim not in [&"attack", &"attack_tornado", &"attack_implosion"]:
			finished.emit(&"idle")


func handle_input(_event: InputEvent) -> void:
	return
