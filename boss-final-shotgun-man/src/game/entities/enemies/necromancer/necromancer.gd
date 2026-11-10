extends Enemy
class_name Necromancer

@export var fire_position_base_x: float = 55.0

func _ready() -> void:
	max_hp = 500
	hp = max_hp


func _look_at_target() -> void:
	super._look_at_target()
	if fire_position:
		fire_position.position.x = -abs(fire_position_base_x) if body.flip_h else abs(fire_position_base_x)
