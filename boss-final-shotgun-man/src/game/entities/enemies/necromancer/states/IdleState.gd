extends NecromancerState

@export var idle_timer: Timer


func enter() -> void:
	character.velocity = Vector2.ZERO
	
	if character.target != null:
		character._play_animation(&"idle_alert")
	else:
		character._play_animation(&"idle")
	idle_timer.start()


func update(delta: float) -> void:
	if not character.is_on_floor():
		character.velocity.y += character.gravity * delta
	else:
		character.velocity.y = 0.0
	character.move_and_slide()
	
	if character._can_see_target():
		finished.emit(&"alert")


func exit() -> void:
	idle_timer.stop()


func _on_idle_timer_timeout() -> void:
	finished.emit(&"walk")


func _handle_body_entered(body: Node) -> void:
	super._handle_body_entered(body)
	character._play_animation(&"alert")


func _handle_body_exited(body: Node) -> void:
	super._handle_body_exited(body)
	character._play_animation(&"idle")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"hurt":
		_restore_animation_after_hurt()
		return
	match anim_name:
		&"alert":
			character._play_animation(&"idle_alert")


func handle_input(_event: InputEvent) -> void:
	return
