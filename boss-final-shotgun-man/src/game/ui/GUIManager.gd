extends Control

## Escena que presenta la información que figura en pantalla durante
## el juego. Maneja tanto lo que es barras de salud como información
## general.

@onready var hearts: RichTextLabel = %Hearts

const HEART_FILLED := "♥"
const COLOR_FILLED := "f22626"

func _ready() -> void:
    GameState.current_player_changed.connect(_on_current_player_changed)
    if GameState.current_player:
        _on_current_player_changed(GameState.current_player)


func _on_current_player_changed(player: Player) -> void:
    player.hp_changed.connect(_on_hp_changed)
    _on_hp_changed(player.hp, player.max_hp)


func _on_hp_changed(hp: int, hp_max: int) -> void:
    var parts: PackedStringArray = []
    for i in hp:
        parts.append("[color=#%s]%s[/color]" % [COLOR_FILLED, HEART_FILLED])
    
    hearts.text = " ".join(parts)
