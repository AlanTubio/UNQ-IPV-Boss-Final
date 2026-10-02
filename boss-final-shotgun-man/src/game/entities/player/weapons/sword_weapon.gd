extends AbstractWeapon

@onready var attacks_anim: AnimationPlayer = $AttacksAnim
@onready var sword_pivot: Node2D = $SwordPivot
@onready var cut_area: Area2D = $SwordPivot/CutArea

## Referencia al personaje, guardada en update_weapon para
## poder accederla desde los callbacks de señales
var _character: Node

## Flag para disparar el wall jump solo una vez por ataque,
## evitando múltiples triggers mientras la animación sigue activa
var _wall_jumped_this_attack: bool = false


func _ready() -> void:
	attacks_anim.animation_finished.connect(_on_attacks_anim_animation_finished)


func enter() -> void:
	super.enter()
	attacks_anim.play(&"RESET")


func exit() -> void:
	attacks_anim.play(&"RESET")
	super.exit()


func update_weapon(_delta: float, character: Node, can_attack: bool = true) -> void:
	_character = character

	# Mientras la animación de corte está activa, chequeamos overlap
	# con get_overlapping_bodies() en lugar de body_entered,
	# ya que body_entered no re-dispara si el área ya estaba en contacto
	if attacks_anim.is_playing() && attacks_anim.current_animation == &"cut":
		if not _wall_jumped_this_attack:
			for body in cut_area.get_overlapping_bodies():
				if body is StaticBody2D:
					_wall_jumped_this_attack = true
					_character.do_wall_jump()
					break
		return

	if not can_attack:
		return

	if Input.is_action_just_pressed(&"attack_weapon1"):
		_wall_jumped_this_attack = false
		if get_global_mouse_position().x < global_position.x:
			sword_pivot.scale.x = -1.0
		else:
			sword_pivot.scale.x = 1.0

		attacks_anim.play(&"cut")


func _on_attacks_anim_animation_finished(_animation_name: StringName) -> void:
	attacks_anim.play(&"RESET")
