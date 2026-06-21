class_name MosesController
extends Node2D

signal player_detected

@export var run_duration := 10.0

@onready var _animation: AnimatedSprite2D = %AnimatedMoses
@onready var _player_detector: Area2D = %PlayerDetector

func _ready() -> void:
	_player_detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		player_detected.emit()
		_animation.play("turn_around")

func run_to(target_global_position_x: float) -> void:
	_animation.play("run")
	var target_position := Vector2(target_global_position_x, global_position.y)
	var tween := create_tween().bind_node(self)
	tween.tween_property(self, "global_position", target_position, run_duration)
		#.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	_animation.play("idle")
