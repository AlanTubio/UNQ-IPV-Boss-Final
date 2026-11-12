@abstract
class_name NecromancerState extends AbstractState

var character: Necromancer
var animation_before_hurt: StringName = &""


func handle_event(event: StringName, ...values: Array) -> void:
	match event:
		&"body_entered":
			_handle_body_entered(values.front())
		&"body_exited":
			_handle_body_exited(values.front())
		&"hit":
			_handle_hit(values.front())
		&"hp_changed":
			_handle_hp_changed(values[0], values[1])


func _handle_body_entered(body: Node) -> void:
	if character.target == null:
		character.target = body


func _handle_body_exited(body: Node) -> void:
	if body == character.target:
		character.target = null


func _handle_hit(amount: int) -> void:
	if character.get_current_animation() != &"hurt":
		animation_before_hurt = character.get_current_animation()
	character._sum_hp(amount)
	if character.hp > 0:
		character._play_animation(&"hurt")


func _restore_animation_after_hurt() -> void:
	if animation_before_hurt != &"":
		character._play_animation(animation_before_hurt)
	animation_before_hurt = &""


func _handle_hp_changed(hp: int, _max_hp: int) -> void:
	if hp == 0:
		finished.emit(&"dead")
