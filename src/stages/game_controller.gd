class_name GameController
extends Node2D

@onready var player: PlayerController = %Player
@onready var moses: MosesController = %Moses

var _current_stage: StageController

var stages: Array[StageController] = []

func _ready() -> void:
	moses.player_detected.connect(_on_moses_detected_player)
	for child in %Stages.get_children():
		if child is StageController:
			stages.append(child)
	_start_stage(stages.pop_front())

func _on_moses_detected_player() -> void:
	if stages.is_empty():
		print("You Win!")
		# TODO
	else:
		_start_stage(stages.pop_front())
		print("TODO advance to next stage")
		# make moses run to the next stage end and 

func _start_stage(stage: StageController) -> void:
	print("next stage")
	if is_instance_valid(_current_stage):
		_current_stage.stop()
		await get_tree().create_timer(1.0).timeout
		# TODO
		# stop all input
		# shift camera to moses
		await moses.run_to(stage.get_global_moses_position_x())
		# resume with camera and enable input
	else:
		moses.global_position.x = stage.get_global_moses_position_x()
	_current_stage = stage
	_current_stage.initialize(player)
	_current_stage.start() # TODO only do this when the player does some input
