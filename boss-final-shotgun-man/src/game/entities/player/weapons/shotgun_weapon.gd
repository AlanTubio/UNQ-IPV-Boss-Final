extends AbstractWeapon

## Script de la escopeta. Dispara un cono de proyectiles al presionar attack_weapon1.
## No emite wall_hit, por lo que no activa el wall-jump del personaje.

@onready var attacks_anim: AnimationPlayer = $AttacksAnim
@onready var shotgun_pivot: Node2D = $ShotgunPivot
@onready var shotgun_sprite: Sprite2D = $ShotgunPivot/ShotgunSprite
@onready var muzzle_point: Marker2D = $ShotgunPivot/MuzzlePoint
@onready var shoot_cooldown: Timer = $ShootCooldown

## Escena del proyectil a instanciar
@export var bullet_scene: PackedScene

## Cantidad de perdigones por disparo
@export var pellet_count: int = 5

## Spread total del cono en grados (el cono va de -spread_deg/2 a +spread_deg/2)
@export var spread_deg: float = 40.0


func _ready() -> void:
	attacks_anim.animation_finished.connect(_on_attacks_anim_animation_finished)


func enter() -> void:
	super.enter()
	attacks_anim.play(&"RESET")


func exit() -> void:
	attacks_anim.play(&"RESET")
	super.exit()


func update_weapon(_delta: float, character: Node, can_attack: bool = true) -> void:
	if not can_attack:
		return

	# Orientamos la escopeta hacia el mouse en cada frame
	_aim_at_mouse(character)

	if attacks_anim.is_playing() and attacks_anim.current_animation != &"RESET":
		return

	if not shoot_cooldown.is_stopped():
		return

	if Input.is_action_just_pressed(&"attack_weapon1"):
		attacks_anim.play(&"shoot")
		_fire(character)
		shoot_cooldown.start()


## Orienta el pivot de la escopeta hacia el mouse.
## Tambien selecciona la textura según si el personaje está en el aire o no.
func _aim_at_mouse(character: Node) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	# Rotamos el pivot hacia el mouse usando la posición global del arma como origen
	var angle: float = (mouse_pos - global_position).angle()
	shotgun_pivot.rotation = angle

	# Corregimos el flip del sprite según el lado hacia el que apunta
	if mouse_pos.x < global_position.x:
		shotgun_pivot.scale.y = -1.0
	else:
		shotgun_pivot.scale.y = 1.0


## Instancia los pellets en el contenedor de proyectiles con el spread del cono.
func _fire(character: Node) -> void:
	if bullet_scene == null or projectile_container == null:
		return

	var base_angle: float = (get_global_mouse_position() - muzzle_point.global_position).angle()
	var half_spread: float = deg_to_rad(spread_deg / 2.0)

	for i in pellet_count:
		# Distribuimos los pellets uniformemente dentro del spread
		var t: float = float(i) / float(pellet_count - 1) if pellet_count > 1 else 0.0
		var spread_angle: float = lerp(-half_spread, half_spread, t)
		var direction: Vector2 = Vector2.from_angle(base_angle + spread_angle)

		var bullet: Bullet = bullet_scene.instantiate()
		bullet.direction = direction
		bullet.global_position = muzzle_point.global_position
		projectile_container.add_child(bullet)


func _on_attacks_anim_animation_finished(_animation_name: StringName) -> void:
	attacks_anim.play(&"RESET")
