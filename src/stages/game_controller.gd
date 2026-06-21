class_name GameController
extends Node2D

@onready var player: PlayerController = %Player
@onready var moses: MosesController = %Moses

@onready var stage1: StageController = %Stage1
@onready var stage2: StageController = %Stage2
@onready var stage3: StageController = %Stage3

var _current_stage: StageController

func _ready() -> void:
	moses.player_detected.connect(_on_moses_detected_player)
	_start_stage(stage1)

func _on_moses_detected_player() -> void:
	if _current_stage == stage3:
		print("You Win!")
		# TODO
	else:
		_start_stage(stage2)
		print("TODO advance to next stage")
		# if last stage: win state!
		# stop all input
		# make moses run to the next stage end and follow with camera
		# resume with camera and enable input

func _start_stage(stage: StageController) -> void:
	print("next stage")
	if is_instance_valid(_current_stage):
		_current_stage.stop()
	_current_stage = stage
	_current_stage.initialize(player)
	_current_stage.start() # TODO only do this when the player does some input
