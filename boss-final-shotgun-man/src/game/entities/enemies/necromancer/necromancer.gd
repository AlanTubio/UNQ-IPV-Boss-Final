extends Enemy
class_name Necromancer

@export_group("Shield")
@export var shield_max_hits: int = 1
@export var shield_regen_time: float = 10.0
@export var shield_break_grace_time: float = 0.5

@export_group("Attacks")
@export var tornado_scene: PackedScene
@export var implosion_scene: PackedScene

@export var tornado_cooldown: float = 8.0
@export var implosion_cooldown: float = 7.0
@export var implosion_offset_y: float = 30.0

@export var fire_position_base_x: float = 55.0

@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var shield_anim: AnimationPlayer = $ShieldAnimationPlayer
@onready var shield_regen_timer: Timer = $ShieldRegenTimer
@onready var shield_grace_timer: Timer = $ShieldGraceTimer

@onready var tornado_cooldown_timer: Timer = $TornadoCooldownTimer
@onready var implosion_cooldown_timer: Timer = $ImplosionCooldownTimer

@onready var audio_implotion: AudioStreamPlayer2D = $ImplotionSound

var shield_active: bool = true
var shield_hits_remaining: int = 1
var is_shield_breaking: bool = false
var current_attack: StringName = &"projectile"

# Posición en el suelo fijada para el Tornado
var tornado_target_pos: Vector2 = Vector2.ZERO


func _ready() -> void:
	super._ready()
	shield_hits_remaining = shield_max_hits
	shield_active = true
	is_shield_breaking = false
	
	shield_grace_timer.timeout.connect(_on_shield_grace_timeout)
	shield_regen_timer.timeout.connect(_on_shield_regen_timeout)
	
	shield_anim.play(&"active")


func _look_at_target() -> void:
	super._look_at_target()
	if fire_position:
		fire_position.position.x = - abs(fire_position_base_x) if body.flip_h else abs(fire_position_base_x)


func notify_hit(amount: int = 1) -> void:
	if is_shield_breaking:
		return
	
	if shield_active:
		shield_hits_remaining -= 1
		if shield_hits_remaining <= 0:
			_break_shield()
		return
	
	super.notify_hit(amount)


func _break_shield() -> void:
	shield_active = false
	is_shield_breaking = true
	shield_anim.play(&"break")
	shield_grace_timer.start(shield_break_grace_time)
	shield_regen_timer.start(shield_regen_time)


func _on_shield_grace_timeout() -> void:
	is_shield_breaking = false


func _on_shield_regen_timeout() -> void:
	shield_active = true
	shield_hits_remaining = shield_max_hits
	is_shield_breaking = false
	shield_anim.play(&"active")


func _is_target_on_floor() -> bool:
	if target == null:
		return false
	if target.has_method("is_on_floor_raycasted"):
		return target.is_on_floor_raycasted()
	if target is CharacterBody2D:
		return target.is_on_floor()
	return false


func _get_ground_position(origin: Vector2) -> Vector2:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(origin - Vector2(0, 10), origin + Vector2(0, 400), 1)
	var result := space_state.intersect_ray(query)
	if result:
		return result.position
	return origin


func can_cast_tornado() -> bool:
	return tornado_scene != null and tornado_cooldown_timer.is_stopped()


func start_tornado_attack() -> void:
	current_attack = &"tornado"
	tornado_cooldown_timer.start(tornado_cooldown)
	if target:
		tornado_target_pos = _get_ground_position(target.global_position)
	_play_animation(&"attack_tornado")


func prepare_next_attack() -> StringName:
	if target == null:
		current_attack = &"projectile"
		return &"attack"
	
	var on_floor: bool = _is_target_on_floor()
	
	if on_floor:
		if can_cast_tornado():
			current_attack = &"tornado"
			tornado_cooldown_timer.start(tornado_cooldown)
			tornado_target_pos = _get_ground_position(target.global_position)
			return &"attack_tornado"
		else:
			current_attack = &"projectile"
			return &"attack"
	
	if implosion_cooldown_timer.is_stopped():
		current_attack = &"implosion"
		implosion_cooldown_timer.start(implosion_cooldown)
		return &"attack_implosion"
	
	current_attack = &"projectile"
	return &"attack"


func cast_current_attack() -> void:
	match current_attack:
		&"projectile":
			_cast_projectile()
		&"tornado":
			_cast_tornado()
		&"implosion":
			_cast_implosion()


func _cast_projectile() -> void:
	if projectile_scene == null or target == null:
		return
	var proj_instance: Node = projectile_scene.instantiate()
	_get_container().add_child(proj_instance)
	var shoot_dir: Vector2 = fire_position.global_position.direction_to(_get_target_aim_position())
	proj_instance.initialize(fire_position.global_position, shoot_dir)


func _cast_tornado() -> void:
	if tornado_scene == null or target == null:
		return
	var tornado: Node = tornado_scene.instantiate()
	_get_container().add_child(tornado)
	
	# Usamos la posición del suelo fijada (o proyectada)
	var spawn_pos: Vector2 = tornado_target_pos
	if spawn_pos == Vector2.ZERO:
		spawn_pos = _get_ground_position(target.global_position)
	tornado.global_position = spawn_pos
	tornado_target_pos = Vector2.ZERO


func _cast_implosion() -> void:
	audio_implotion.play()
	if implosion_scene == null or target == null:
		return
	var implosion: Node = implosion_scene.instantiate()
	_get_container().add_child(implosion)
	implosion.global_position = target.global_position + Vector2(0, -implosion_offset_y)


func _get_container() -> Node:
	if _projectile_container == null:
		_projectile_container = get_parent()
	return _projectile_container

func _remove() -> void:
	get_tree().call_group("goal", "activate")
	super._remove()
