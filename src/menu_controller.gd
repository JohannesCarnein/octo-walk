class_name MenuController
extends Control

signal start_game_requested

@export var music: AudioStream

@onready var start_game_button: Button = %StartButton

func _ready() -> void:
	start_game_button.pressed.connect(start_game_requested.emit)
	MusicPlayer.play(music)
