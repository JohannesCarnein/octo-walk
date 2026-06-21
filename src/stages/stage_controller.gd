class_name StageController
extends Node2D

@onready var _moses_marker: Marker2D = %MosesMarker

func start() -> void:
	pass

func stop() -> void:
	pass

func initialize(_player: Character) -> void:
	pass

func get_global_moses_position_x() -> float:
	return _moses_marker.global_position.x
