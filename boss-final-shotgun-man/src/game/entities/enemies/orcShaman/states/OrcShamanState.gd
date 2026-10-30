@abstract
class_name OrcShamanState extends AbstractState

var character: OrcShaman
var animation_before_hurt: StringName = &""


## Manejamos los eventos de detección de cuerpo aprovechando el polimorfismo
## del parámetro "values" para pasar el cuerpo detectado
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


# Derivamos la detección del target que entra
func _handle_body_entered(body: Node) -> void:
	if character.target == null:
		character.target = body


# Derivamos la detección del target que sale
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
