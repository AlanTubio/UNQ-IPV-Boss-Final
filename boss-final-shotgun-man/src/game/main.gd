extends Node
class_name GameLevel

@onready var main_BGM: AudioStreamPlayer = $MainBGM
@onready var boss_BGM: AudioStreamPlayer = $BossBGM

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
	GameState.boss_alert_changed.connect(_on_boss_alert_changed)


# Funciones que hacen de interfaz para las señales
func _on_level_won() -> void:
	get_tree().reload_current_scene()


func _on_return_requested() -> void:
	get_tree().change_scene_to_file(main_menu_scene_path)


func _on_restart_requested() -> void:
	get_tree().reload_current_scene()


# func _on_boss_area_body_entered(_body: Node2D) -> void:
# 	if !boss_BGM.playing:
# 		boss_BGM.play()
# 		main_BGM.stop()

# func _on_boss_area_body_exited(_body: Node2D) -> void:
# 	if !main_BGM.playing:
# 		boss_BGM.stop()
# 		main_BGM.play()

func _on_boss_alert_changed(is_alert: bool) -> void:
	if is_alert:
		if !boss_BGM.playing:
			boss_BGM.play()
			main_BGM.stop()
	else:
		if !main_BGM.playing:
			boss_BGM.stop()
			main_BGM.play()