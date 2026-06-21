class_name StageController
extends Node2D

@onready var _moses_marker: Marker2D = %MosesMarker

@export var music: AudioStream
@export var moses_music: AudioStream

func start(moses_screen_notifier: VisibleOnScreenNotifier2D) -> void:
	moses_screen_notifier.screen_entered.connect(
		MusicPlayer.play.bind(moses_music),
		CONNECT_ONE_SHOT)

func stop() -> void:
	pass

func initialize(_player: Character) -> void:
	MusicPlayer.play(music)

func get_global_moses_position_x() -> float:
	return _moses_marker.global_position.x
