extends PlayerState

@export var jumps_limit: int = 2

@onready var wall_timer: Timer = $WallTimer

var jumps: int = 0
var can_wall_jump: bool = false
var has_used_wall_jump: bool = false
var resume_after_dash: bool = false


func enter() -> void:
	
	if resume_after_dash and not character.is_on_floor():
		resume_after_dash = false
		if character.velocity.y > 0:
			character._play_animation(&"fall")
		else:
			character._play_animation(&"jump")
		return


	resume_after_dash = false
	jumps = 1
	has_used_wall_jump = false
	can_wall_jump = false
	character.velocity.y = -character.jump_speed
	character._play_animation(&"jump")


func exit() -> void:
	can_wall_jump = false
	if wall_timer and not wall_timer.is_stopped():
		wall_timer.stop()


func handle_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed(&"dash") &&
		character.h_movement_direction != 0
	):
		resume_after_dash = true
		finished.emit(&"dash")
	elif event.is_action_pressed(&"jump"):
		if can_wall_jump:
			can_wall_jump = false
			has_used_wall_jump = true
			if not wall_timer.is_stopped():
				wall_timer.stop()
			character.velocity.y = -character.jump_speed
			character._play_animation(&"jump")
		elif jumps < jumps_limit:
			jumps += 1
			character.velocity.y = -character.jump_speed
			character._play_animation(&"jump")


func update(delta: float) -> void:
	character._handle_weapon_actions(delta)
	character._handle_move_input(delta)
	if character.h_movement_direction == 0:
		character._handle_deacceleration(delta)
	character._apply_movement(delta)
	if character.is_on_floor():
		jumps = 0
		has_used_wall_jump = false
		if character.h_movement_direction == 0:
			finished.emit(&"idle")
		else:
			finished.emit(&"walk")
	else:
		if character.velocity.y > 0:
			character._play_animation(&"fall")
		else:
			character._play_animation(&"jump")


# En este callback manejamos impactos y eventos de pared
func handle_event(event: StringName, ...values: Array) -> void:
	match event:
		&"wall_hit":
			if not character.is_on_floor() and not has_used_wall_jump:
				can_wall_jump = true
				wall_timer.start()
				var push_dir: float = -sign(character.body_pivot.scale.x)
				if push_dir == 0:
					push_dir = -1.0
				character.velocity.x = push_dir * 200.0
		&"hit", &"healed":
			character.sum_hp(values.front())
		&"hp_changed":
			if values.front() == 0:
				finished.emit(&"dead")


func _on_animation_finished(_anim_name: StringName) -> void:
	return


func _on_wall_timer_timeout() -> void:
	can_wall_jump = false
