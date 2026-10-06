extends Area2D
class_name Bullet

## Velocidad de movimiento del proyectil en píxeles por segundo
@export var speed: float = 600.0

## Dirección normalizada de movimiento. Debe asignarse antes de agregar al árbol.
var direction: Vector2 = Vector2.RIGHT


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


## Auto-destrucción al salir de pantalla
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
