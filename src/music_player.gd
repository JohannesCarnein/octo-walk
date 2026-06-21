# class_name MusicPlayer
extends Node

@export var music_cross_fade_duration := 0.5

# Two players to crossfade between music if needed
@onready var player1: AudioStreamPlayer = %AudioStreamPlayer1
@onready var player2: AudioStreamPlayer = %AudioStreamPlayer2

var _current_player: AudioStreamPlayer
func play(music: AudioStream) -> void:
	if is_instance_valid(_current_player) and music == _current_player.stream:
		return
	if _current_player == player1:
		switch_to_player(player2, music)
	else:
		switch_to_player(player1, music)

func switch_to_player(new_player: AudioStreamPlayer, music: AudioStream) -> void:
	var tween := create_tween()
	if is_instance_valid(_current_player) and _current_player.playing:
		tween.tween_property(_current_player, "volume_linear", 0.0, music_cross_fade_duration)
	new_player.stream = music
	new_player.play()
	tween.tween_property(new_player, "volume_linear", 1.0, music_cross_fade_duration)

	_current_player = new_player
