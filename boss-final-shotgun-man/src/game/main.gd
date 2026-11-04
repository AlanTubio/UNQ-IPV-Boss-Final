extends Node
class_name GameLevel

# Regresa al menu principal
signal return_requested()
# Reinicia el nivel
signal restart_requested()
# Inicia el siguiente nivel
signal next_level_requested()

@export_file_path("*.tscn") var main_menu_scene_path: String
@export var mouse_cursor: Texture

func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse_cursor, Input.CURSOR_ARROW, mouse_cursor.get_size() / 2)


# Funciones que hacen de interfaz para las señales
func _on_level_won() -> void:
	next_level_requested.emit()


func _on_return_requested() -> void:
	get_tree().change_scene_to_file(main_menu_scene_path)


func _on_restart_requested() -> void:
	get_tree().reload_current_scene()
