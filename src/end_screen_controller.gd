class_name EndScreenController
extends Control

signal finished

@export var min_display_duration := 2.0
@export var music: AudioStream

@onready var press_any_key_label: Label = %LabelPressAnyKey

var __accept_input := false

func _ready() -> void:
	MusicPlayer.play(music)
	grab_focus()
	press_any_key_label.hide()
	await get_tree().create_timer(min_display_duration).timeout
	__accept_input = true
	press_any_key_label.show()

func _input(event: InputEvent) -> void:
	if not __accept_input:
		return
	if event is InputEventKey:
		finished.emit()
