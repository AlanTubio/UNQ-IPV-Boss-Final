extends Control

## Escena que presenta la información que figura en pantalla durante
## el juego. Maneja tanto lo que es barras de salud como información
## general.

@onready var hearts: HBoxContainer = %Hearts

const HEART_TEXTURE := preload("res://assets/texture/heart.svg")
const HEART_SIZE := Vector2(16, 16)

func _ready() -> void:
    GameState.current_player_changed.connect(_on_current_player_changed)
    if GameState.current_player:
        _on_current_player_changed(GameState.current_player)


func _on_current_player_changed(player: Player) -> void:
    player.hp_changed.connect(_on_hp_changed)
    _on_hp_changed(player.hp, player.max_hp)


func _on_hp_changed(hp: int, hp_max: int) -> void:
    for heart in hearts.get_children():
        heart.queue_free()

    for i in hp:
        var heart := TextureRect.new()
        heart.texture = HEART_TEXTURE
        heart.custom_minimum_size = HEART_SIZE
        heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        hearts.add_child(heart)
