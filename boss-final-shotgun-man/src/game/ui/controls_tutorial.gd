extends Node2D

## Tutorial de controles que aparece al inicio del juego.
## El contenido se desliza de abajo hacia arriba dentro de un ClipBox,
## dando la ilusión de que el pergamino "emerge" desde abajo.

const SLIDE_DURATION := 1.4
const SCROLL_HEIGHT := 460.0  # distancia que viaja hacia arriba (alto del pergamino)

@onready var scroll_root: Node2D = $ClipBox/ScrollRoot

func _ready() -> void:
	# Arranca con todo el contenido debajo del área visible
	scroll_root.position.y = SCROLL_HEIGHT

	# Pequeña espera para que el juego cargue antes de animar
	await get_tree().create_timer(0.5).timeout

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(scroll_root, "position:y", 0.0, SLIDE_DURATION)
