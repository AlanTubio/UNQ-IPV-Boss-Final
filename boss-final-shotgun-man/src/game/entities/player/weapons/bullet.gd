extends Projectile
class_name Bullet

## Velocidad del perdigón en píxeles por segundo.
@export var speed: float = 600.0


func _ready() -> void:
	velocity = speed
