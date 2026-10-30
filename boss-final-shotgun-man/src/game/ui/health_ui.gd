extends Control

@onready var hearts: Label = $Hearts

var player: Player


func _ready() -> void:
	player = GameState.current_player
	if player == null:
		return
	player.hp_changed.connect(_on_player_hp_changed)
	_on_player_hp_changed(player.hp, player.max_hp)


func _on_player_hp_changed(current_hp: int, max_hp: int) -> void:
	var filled: String = String.chr(9829).repeat(current_hp).strip_edges()
	var empty: String = String.chr(9825).repeat(max_hp - current_hp).strip_edges()
	hearts.text = filled + (" " if filled and empty else "") + empty
