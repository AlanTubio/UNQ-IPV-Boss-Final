extends Control

## Escena que presenta la información que figura en pantalla durante
## el juego. Maneja tanto lo que es barras de salud como información
## general.

@onready var hearts: HBoxContainer = %Hp
@onready var HEART_TEXTURE: TextureProgressBar = $HpProgress

func _ready() -> void:
	HEART_TEXTURE.hide()
	GameState.current_player_changed.connect(_on_current_player_changed)
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
