extends Area2D
class_name FireTornado

@export var duration: float = 5.0
@export var damage: int = 1
@export var damage_cooldown: float = 1.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var duration_timer: Timer = $DurationTimer
@onready var sprite: Sprite2D = $Sprite2D

var _bodies_inside: Dictionary = {}

func _ready() -> void:
	monitoring = false
	duration_timer.wait_time = duration
	duration_timer.one_shot = true
	
	animation_player.play(&"start")
	animation_player.queue(&"spin")


func _physics_process(delta: float) -> void:
	for body in _bodies_inside.keys():
		_bodies_inside[body] += delta
		if _bodies_inside[body] >= damage_cooldown:
			_apply_damage(body)
			_bodies_inside[body] = 0.0


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("notify_hit"):
		_apply_damage(body)
		_bodies_inside[body] = 0.0


func _on_body_exited(body: Node2D) -> void:
	_bodies_inside.erase(body)


func _apply_damage(body: Node2D) -> void:
	if body.has_method("notify_hit"):
		body.notify_hit(-damage)


func _on_duration_timeout() -> void:
	set_physics_process(false)
	monitoring = false
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(queue_free)
	animation_player.play(&"end")


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == &"spin":
		monitoring = true
		duration_timer.start()
