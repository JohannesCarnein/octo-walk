class_name EndScreenController
extends Control

signal finished

@export var music: AudioStream

func _ready() -> void:
	MusicPlayer.play(music)
	grab_focus()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		finished.emit()
