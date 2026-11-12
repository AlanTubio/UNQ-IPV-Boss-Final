extends NecromancerState

@export var wander_radius: Vector2 = Vector2(500, 0)
@export var speed: float = 30.0
@export var max_speed: float = 60.0
@export var pathfinding_step_threshold: float = 5.0

var path: PackedVector2Array = PackedVector2Array()


func enter() -> void:
	if character.pathfinding != null:
		var random_point: Vector2 = (
			character.global_position +
			Vector2(
				randf_range(-wander_radius.x, wander_radius.x),
				randf_range(-wander_radius.y, wander_radius.y)
			)
		)
		
		path = character.pathfinding.get_simple_path(
			character.global_position,
			random_point
		)
		
		if path.is_empty() || path.size() == 1:
			finished.emit(&"idle")
		else:
			if character.target != null:
				character._play_animation(&"walk_alert")
			else:
				character._play_animation(&"walk")
	else:
		finished.emit(&"idle")


func exit() -> void:
	path = PackedVector2Array()


func update(delta: float) -> void:
	if character._can_see_target():
		finished.emit(&"alert")
		return
	
	if path.is_empty():
		character.velocity.x = 0.0
		finished.emit(&"idle")
		return
	
	var next_point: Vector2 = path[0]
	
	while (
		abs(character.global_position.x - next_point.x) < pathfinding_step_threshold
	):
		path.remove_at(0)
		
		if path.is_empty():
			character.velocity.x = 0.0
			finished.emit(&"idle")
			return
		
		next_point = path[0]
	
	var direction_x: float = sign(next_point.x - character.global_position.x)
	character.velocity.x = move_toward(character.velocity.x, direction_x * max_speed, speed)
	
	if not character.is_on_floor():
		character.velocity.y += character.gravity * delta
	else:
		character.velocity.y = 0.0
	
	character.move_and_slide()
	
	if direction_x != 0:
		character.body.flip_h = direction_x < 0


func _handle_body_entered(body: Node) -> void:
	super._handle_body_entered(body)
	character._play_animation(&"alert")


func _handle_body_exited(body: Node) -> void:
	super._handle_body_exited(body)
	character._play_animation(&"walk")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"hurt":
		_restore_animation_after_hurt()
		return
	match anim_name:
		&"alert":
			character._play_animation(&"walk_alert")


func handle_input(_event: InputEvent) -> void:
	return
