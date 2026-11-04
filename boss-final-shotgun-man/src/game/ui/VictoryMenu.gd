extends Control

## Menú de victoria genérico. Solo se presenta si se levanta la signal
## de "level_won" en GameState.

signal next_selected()
signal return_selected()


func _ready() -> void:
	hide_custom()
	GameState.level_won.connect(_on_level_won)


func _on_level_won() -> void:
	show_custom()


func _on_next_button_pressed() -> void:
	hide_custom()
	next_selected.emit()


func _on_return_button_pressed() -> void:
	hide_custom()
	return_selected.emit()


func show_custom() -> void:
	show()
	get_tree().paused = true


func hide_custom() -> void:
	hide()
	get_tree().paused = false
