extends AbstractWeapon

@onready var attacks_anim: AnimationPlayer = $AttacksAnim
@onready var sword_pivot: Node2D = $SwordPivot


func _ready() -> void:
	attacks_anim.animation_finished.connect(_on_attacks_anim_animation_finished)


func enter() -> void:
	super.enter()
	attacks_anim.play(&"RESET")


func exit() -> void:
	attacks_anim.play(&"RESET")
	super.exit()


func update_weapon(_delta: float, _character: Node, can_attack: bool = true) -> void:
	if not can_attack:
		return

	if attacks_anim.is_playing() && attacks_anim.current_animation != &"RESET":
		return

	if Input.is_action_just_pressed(&"attack_weapon1"):
		if get_global_mouse_position().x < global_position.x:
			sword_pivot.scale.x = -1.0
		else:
			sword_pivot.scale.x = 1.0

		attacks_anim.play(&"cut")


func _on_attacks_anim_animation_finished(_animation_name: StringName) -> void:
	attacks_anim.play(&"RESET")
