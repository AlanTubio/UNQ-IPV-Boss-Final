extends Area2D
class_name VoidImplosion

@export var damage: int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var _has_damaged: bool = false
var _is_damage_active: bool = false

func _ready() -> void:
	monitoring = false
	collision_shape.disabled = true
	animation_player.animation_finished.connect(_on_animation_finished)
	animation_player.play(&"implode")


func enable_damage() -> void:
	_is_damage_active = true
	monitoring = true
	collision_shape.disabled = false
	for body in get_overlapping_bodies():
		_on_body_entered(body)


func disable_damage() -> void:
	_is_damage_active = false
	monitoring = false
	collision_shape.disabled = true


func _on_body_entered(body: Node2D) -> void:
	if _is_damage_active and not _has_damaged and body.has_method("notify_hit"):
		_has_damaged = true
		body.notify_hit(-damage)


func _on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
