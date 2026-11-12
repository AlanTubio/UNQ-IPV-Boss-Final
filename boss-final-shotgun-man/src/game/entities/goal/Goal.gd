extends Area2D

@onready var portal: AnimatedSprite2D = $Portal
@onready var audio_obelisk: AudioStreamPlayer2D = $ObeliskSound

var won: bool = false


func _ready() -> void:
	hide()
	monitoring = false
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node) -> void:
	if won:
		return
	print("You win!")
	won = true
	portal.play("open")


func _on_portal_animation_finished() -> void:
	if portal.animation == "open":
		portal.play("idle_open")
		GameState.notify_level_won()

func activate() -> void:
	show()
	monitoring = true
	audio_obelisk.play()
	portal.play("idle")
