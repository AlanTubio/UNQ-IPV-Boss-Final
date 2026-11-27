extends Control

## Escena que presenta la información que figura en pantalla durante
## el juego. Maneja tanto lo que es barras de salud como información
## general.

@onready var hearts: HBoxContainer = %Hp
@onready var HEART_TEXTURE: TextureProgressBar = $HpProgress
@onready var timer: Timer = $Timer
@onready var time_label: Label = $Time

var seconds_elapsed: int = 0

func _ready() -> void:
	HEART_TEXTURE.hide()
	GameState.current_player_changed.connect(_on_current_player_changed)
	GameState.level_won.connect(_on_level_won)
	if GameState.current_player:
		_on_current_player_changed(GameState.current_player)


func _on_current_player_changed(player: Player) -> void:
	player.hp_changed.connect(_on_hp_changed)
	_on_hp_changed(player.hp, player.max_hp)


func _on_hp_changed(hp: int, hp_max: int) -> void:
	for heart in hearts.get_children():
		heart.queue_free()

	for i in hp_max:
		var heart := HEART_TEXTURE.duplicate() as TextureProgressBar
		heart.value = 1 if i < hp else 0
		heart.show()
		hearts.add_child(heart)


func _on_timer_timeout() -> void:
	seconds_elapsed += 1
	var minutes: int = seconds_elapsed / 60
	var seconds: int = seconds_elapsed % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func _on_level_won() -> void:
	timer.stop()
	GameState.final_time = time_label.text
