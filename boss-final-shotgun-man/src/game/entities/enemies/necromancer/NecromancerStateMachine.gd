extends GenericStateMachine
class_name NecromancerStateMachine

@export var character: Necromancer
@export var dead_state: NecromancerState

func _setup() -> void:
	for state: NecromancerState in states_list:
		state.character = character
	character.hit.connect(notify_hit)
	character.hp_changed.connect(_on_turret_hp_changed)


func notify_body_entered(body: Node) -> void:
	current_state.handle_event(&"body_entered", body)
	GameState.notify_boss_alert(true)


func notify_body_exited(body: Node) -> void:
	current_state.handle_event(&"body_exited", body)
	GameState.notify_boss_alert(false)


func notify_hit(amount: int) -> void:
	current_state.handle_event(&"hit", amount)


func _on_turret_hp_changed(hp: Variant, max_hp: Variant) -> void:
	current_state.handle_event(&"hp_changed", hp, max_hp)


func _on_body_animation_finished() -> void:
	_on_animation_finished(character.get_current_animation())
