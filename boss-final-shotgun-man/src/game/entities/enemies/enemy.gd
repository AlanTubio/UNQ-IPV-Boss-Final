extends CharacterBody2D
class_name Enemy

signal hit(amount: int)
signal hp_changed(hp, max_hp)

@onready var fire_position: Node2D = $FirePosition
@onready var raycast: RayCast2D = $RayCast2D
@onready var body: Sprite2D = $Body
@onready var animation_player: AnimationPlayer = $AnimationEnemy

@export var projectile_scene: PackedScene
@export var pathfinding: PathfindAstar
@export var target_aim_offset: Vector2 = Vector2(0, -45)


var target: Node2D
var _projectile_container: Node

@export var max_hp: int = 100
var hp: int = max_hp
@export var gravity: float = 625.0

## Flag de ayuda para saber identificar el estado de actividad
var dead: bool = false

func _ready() -> void:
	pass


func initialize(turret_pos: Vector2, projectile_container: Node) -> void:
	global_position = turret_pos
	self._projectile_container = projectile_container


func _fire() -> void:
	if target == null || not _can_see_target():
		return

	var proj_instance: Node = projectile_scene.instantiate()
	if _projectile_container == null:
		_projectile_container = get_parent()
		_projectile_container.add_child(proj_instance)
	else:
		_projectile_container.add_child(proj_instance)
	proj_instance.initialize(
		fire_position.global_position,
		fire_position.global_position.direction_to(_get_target_aim_position())
	)


# Al igual que con el script del player, abstraemos a una función la detección del target
func _can_see_target() -> bool:
	if target == null:
		return false
	raycast.target_position = raycast.to_local(_get_target_aim_position())
	raycast.force_raycast_update()
	return raycast.is_colliding() && raycast.get_collider() == target


func _get_target_aim_position() -> Vector2:
	return target.global_position + target_aim_offset


# Damos vuelta el cuerpo para que mire al objetivo en el eje x
# y usamos la dirección a la que se casteó el raycast
# Otra manera sería hacer (target.global_position - global_position).x < 0
# La ventaja de esta manera es que no dependemos de que exista un target
func _look_at_target() -> void:
	body.flip_h = raycast.target_position.x < 0


# Esta función ya no llama directamente a remove, sino que inhabilita las
# colisiones con el mundo, pausa todo lo demás y ejecuta una animación de muerte
# dependiendo de si el enemigo esta o no alerta
func notify_hit(amount: int = 1) -> void:
	hit.emit(amount)


func _sum_hp(amount: int) -> void:
	hp = clamp(hp + amount, 0, max_hp)
	hp_changed.emit(hp, max_hp)
	
func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


# Wrapper sobre el llamado a animación para tener un solo punto de entrada controlable
# (en el caso de que necesitemos expandir la lógica o debuggear, por ejemplo)
func _play_animation(animation: String) -> void:
	if animation_player.has_animation(animation):
		animation_player.play(animation)


# Wrapper para facilitar el acceso a la animación actual
func get_current_animation() -> String:
	return animation_player.current_animation
