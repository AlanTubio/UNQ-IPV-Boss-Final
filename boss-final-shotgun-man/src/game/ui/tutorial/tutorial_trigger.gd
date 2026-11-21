extends Area2D
class_name TutorialTrigger

## Trigger invisible para hints tutoriales contextuales.
## Al entrar el Player se muestra suavemente el cartel flotante.
## Al salir el Player se desvanece suavemente.

@export var starts_visible: bool = false

@onready var prompt: Control = $Prompt
@onready var sound: AudioStreamPlayer2D = get_node_or_null("UISound")

var _tween: Tween
var _is_visible: bool = false
var _base_prompt_y: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if prompt:
		_base_prompt_y = prompt.position.y
		if starts_visible:
			prompt.modulate.a = 1.0
			_is_visible = true
		else:
			prompt.modulate.a = 0.0
			_is_visible = false
	
	call_deferred(&"_check_initial_overlap")


func _process(_delta: float) -> void:
	if _is_visible and prompt:
		# Flotación sinusoidal sutil para darle dinamismo
		prompt.position.y = _base_prompt_y + sin(Time.get_ticks_msec() * 0.003) * 2.5


func _check_initial_overlap() -> void:
	if starts_visible:
		return
	for b in get_overlapping_bodies():
		if _is_player(b):
			show_prompt()
			break


func _on_body_entered(body: Node2D) -> void:
	if _is_player(body):
		show_prompt()


func _on_body_exited(body: Node2D) -> void:
	if _is_player(body):
		hide_prompt()


func _is_player(body: Node2D) -> bool:
	return body is Player or body.name == "Player"


func show_prompt() -> void:
	if _is_visible:
		return
	_is_visible = true
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(prompt, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	if sound and not sound.playing:
		sound.play()


func hide_prompt() -> void:
	if not _is_visible:
		return
	_is_visible = false
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(prompt, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
