extends Control

## Menú de victoria genérico. Solo se presenta si se levanta la signal
## de "level_won" en GameState.

signal next_selected()
signal return_selected()

@onready var audioBGM = $AudioStreamPlayer
@onready var audioHover = $AudioHover
@onready var time_label: Label = $Panel/Time


func _ready() -> void:
	hide_custom()
	GameState.level_won.connect(_on_level_won)


func _on_level_won() -> void:
	audioBGM.play()
	time_label.text = "Time: " + GameState.final_time
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


func _on_button_mouse_entered() -> void:
	audioHover.play()
