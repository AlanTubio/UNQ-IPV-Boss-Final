extends CharacterBody2D
class_name Enemy

signal hit(amount: int)
signal hp_changed(hp: int, max_hp: int)

@export var max_hp: int = 5
var hp: int = max_hp

## Flag de ayuda para identificar estado de actividad
var dead: bool = false

# Nodos comunes que todos los enemigos van a tener
@onready var body_anim: AnimatedSprite2D = $Body
@onready var hp_progress: ProgressBar = $HpProgress

var hp_tween: Tween

func _ready() -> void:
	hp = max_hp
	if hp_progress:
		hp_progress.max_value = max_hp
		hp_progress.value = hp
		hp_progress.modulate = Color.TRANSPARENT

## Punto de entrada para recibir daño / curación
func notify_hit(amount: int = 1) -> void:
	hit.emit(amount)

func _sum_hp(amount: int) -> void:
	hp = clamp(hp + amount, 0, max_hp)
	if hp_progress:
		hp_progress.max_value = max_hp
		hp_progress.value = hp
		hp_changed.emit(hp, max_hp)
		
		if hp_tween:
			hp_tween.kill()
		hp_tween = create_tween()
		hp_progress.modulate = Color.WHITE
		hp_tween.tween_property(hp_progress, "modulate", Color.TRANSPARENT, 5.0)

func _remove() -> void:
	if get_parent():
		get_parent().remove_child(self)
	queue_free()

# Wrappers de animación para la base
func _play_animation(animation: String) -> void:
	if body_anim and body_anim.sprite_frames and body_anim.sprite_frames.has_animation(animation):
		body_anim.play(animation)

func get_current_animation() -> String:
	if body_anim:
		return body_anim.animation
	return ""