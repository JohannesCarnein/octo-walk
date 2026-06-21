class_name GameController
extends Node2D

signal finished

@onready var player: Character = %Player
@onready var moses: MosesController = %Moses

@onready var moses_camera: PhantomCamera2D = %CameraMoses

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
		await get_tree().create_timer(2.0).timeout
		finished.emit()
	else:
		_start_stage(stages.pop_front())

func _start_stage(stage: StageController) -> void:
	if is_instance_valid(_current_stage):
		_current_stage.stop()
		# stop all input
		# player.process_mode = Node.PROCESS_MODE_DISABLED
		# player.set_physics_process(false) # TODO does not work
		# shift camera to moses
		moses_camera.priority = 10
		await get_tree().create_timer(2.0).timeout
		# make moses run away while following him
		await moses.run_to(stage.get_global_moses_position_x())
		# resume with camera and enable input
		moses_camera.priority = 0
		# player.process_mode = Node.PROCESS_MODE_INHERIT
		# player.set_physics_process(true)
		EventBus.refill_water.emit()
	else:
		moses.global_position.x = stage.get_global_moses_position_x()
	_current_stage = stage
	_current_stage.initialize(player)
	_current_stage.start() # TODO only do this when the player does some input
