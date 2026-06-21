class_name Character
extends Node2D

@export var min_strength: float = 1
@export var max_strength: float = 20
@export var move_speed: float = 800
@export var time_till_max_strength: float = 3

@export var cam: Camera2D

var jump_boost:float = 1
var jump_tween1: Tween
var jump_tween2: Tween
var _time_under_tension: float = 0:
	set(value):
		_time_under_tension = clamp(value, 0, time_till_max_strength)

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	draw_line(Vector2(100, 0), Vector2(100, get_mapped_tut() * -200), lerp(Color.GREEN_YELLOW, Color.CRIMSON, get_mapped_tut()))

func _physics_process(delta: float) -> void:
	var moved: bool = false
	var strength: float = move_speed * delta * get_strength()
	if Input.is_key_pressed(KEY_Q):
		Lstep_left(strength)
		moved = true
	if Input.is_key_pressed(KEY_W):
		Lstep_right(strength)
		moved = true
	if Input.is_key_pressed(KEY_O):
		Rstep_left(strength)
		moved = true
	if Input.is_key_pressed(KEY_P):
		Rstep_right(strength)
		moved = true
	prevent_inverted_knee(delta * 0.2)
	if moved:
		_time_under_tension += delta
	else:
		_time_under_tension -= delta * 3
	var center_of_mass: Vector2 = %ActiveRagdoll.get_center_of_mass()
	var skeleton_pos: Vector2 = %SkeletonHolder.global_position
	var character_move: Vector2 = lerp(skeleton_pos, center_of_mass + Vector2.UP * 100 * jump_boost, clamp(5 * delta, 0, 1))
	%SkeletonHolder.global_position = character_move + (jump_boost - 1) * Vector2(10,5)
	if cam:
		cam.global_position = center_of_mass
		
func get_mapped_tut() -> float:
	return remap(_time_under_tension, 0, time_till_max_strength, 0, 1)
	
func get_strength() -> float:
	return lerpf(min_strength, max_strength, get_mapped_tut()) * jump_boost
	
func prevent_inverted_knee(strength: float) -> void:
	%B_Leg2L.rotate(strength)
	%B_kneeL.rotate(2 * strength)
	%B_Leg2R.rotate(strength)
	%B_kneeR.rotate(2 * strength)
	
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q:
			play_anim("MoveL")
		if event.keycode == KEY_W:
			play_anim("MoveR")
		if event.keycode == KEY_SPACE:
			jump()

func jump() -> void:
	if !jump_tween1:
		jump_tween1 = create_tween()
		jump_tween1.tween_property(%StepTargets, "position", Vector2(-200, 200), 0.1)
		jump_tween1.tween_property(%StepTargets, "position", Vector2.ZERO, 0.2)
		%ActiveRagdoll.bone_to_body[%B_FootL].apply_impulse(Vector2(50, -500))
		%ActiveRagdoll.bone_to_body[%B_FootR].apply_impulse(Vector2(50, -500))
		%ActiveRagdoll.bone_to_body[%B_Root].apply_impulse(Vector2(100, -1000))
	elif jump_tween1.is_running():
		pass
	else:
		jump_tween1 = null
		jump()

	if !jump_tween2:
		jump_tween2 = create_tween()
		jump_tween2.tween_property(self, "jump_boost", 3.0, 0.1)
		jump_tween2.tween_property(self, "jump_boost", 1.0, 0.2)
	
	elif jump_tween2.is_running():
		pass
	else:
		jump_tween2 = null
		jump()



func play_anim(anim_name: String) -> void:
	#%AnimationPlayer.play(anim_name)
	pass

func Lstep_left(strength: float) -> void:
	%FootLTarget.approach_target(%StepTargetL, strength)
	
func Lstep_right(strength: float) -> void:
	%FootLTarget.approach_target(%StepTargetR, strength)
	
func Rstep_left(strength: float) -> void:
	%FootRTarget.approach_target(%StepTargetL, strength)
	
func Rstep_right(strength: float) -> void:
	%FootRTarget.approach_target(%StepTargetR, strength)
	
