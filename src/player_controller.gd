class_name PlayerController
extends CharacterBody2D

@onready var audio_steps: AudioStreamPlayer2D = %AudioStreamSteps
@onready var audio_armor: AudioStreamPlayer2D = %AudioStreamArmor

########## Placeholder Code
@export var speed := 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
	else:
		velocity.x = 0.0
	if Input.is_key_pressed(KEY_SPACE):
		audio_steps.play()
	if Input.is_key_pressed(KEY_B):
		audio_armor.play()

func _physics_process(_delta: float) -> void:
	move_and_slide()
