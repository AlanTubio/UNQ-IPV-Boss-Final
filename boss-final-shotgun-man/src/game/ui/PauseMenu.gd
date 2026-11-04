extends Control

## Menú de pausa genérico, abierto utilizando la acción "pause_menu"
## (por default la tecla Esc).

signal return_selected()
signal restart_selected()

@onready var options_menu: Control = $OptionsMenu


func _ready() -> void:
	hide_custom()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(&"pause_menu"):
		if options_menu.visible:
			options_menu.hide()
		else:
			if visible:
				hide_custom()
			else:
				show_custom()


func _on_resume_button_pressed() -> void:
	hide_custom()


func _on_restart_button_pressed() -> void:
	hide_custom()
	restart_selected.emit()


func _on_return_button_pressed() -> void:
	hide_custom()
	return_selected.emit()


func show_custom() -> void:
	show()
	get_tree().paused = true


func hide_custom() -> void:
	hide()
	get_tree().paused = false
