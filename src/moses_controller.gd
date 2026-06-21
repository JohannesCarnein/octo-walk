class_name MosesController
extends Node2D

signal player_detected

@onready var _player_detector: Area2D = %PlayerDetector

func _ready() -> void:
	_player_detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		player_detected.emit()
