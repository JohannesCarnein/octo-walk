class_name Retractable
extends Node2D

@export var retract_ratio: Vector2 = Vector2(1, 0.5):
	get:
		return retract_ratio.normalized()
@export var target_ratio: Vector2 = Vector2(0.3, 1):
	get:
		return target_ratio.normalized()


var should_return: bool = true
@onready var restpose_marker: Marker2D = Marker2D.new()

func _ready() -> void:
	var pos:= global_position
	await get_tree().process_frame

	get_parent().add_child(restpose_marker)
	restpose_marker.global_position = pos
	queue_redraw()
	
func _draw():
	if restpose_marker != null:
		draw_circle(to_local(restpose_marker.global_position), 10, Color.PURPLE)

func _physics_process(delta: float) -> void:
	var strength: float = 500 * delta
	if should_return:
		pass
		approach_restpose(strength)
	should_return = true
	
func approach_target(target: Node2D, strength: float) -> void:
	var target_pos: Vector2 = target.global_position
	var curent_pos: Vector2 = global_position
	var direction: Vector2 = curent_pos.direction_to(target_pos)
	var delta: Vector2 =  direction * min(curent_pos.distance_to(target_pos), strength)# * target_ratio
	global_position += delta
	should_return = false
	
func approach_restpose(strength: float) -> void:
	
	if restpose_marker != null:
		var target_pos:Vector2 = restpose_marker.global_position
		#global_position = global_position.move_toward(target_pos, strength)
		var distance: float = global_position.distance_to(target_pos)
		var dir: Vector2 = global_position.direction_to(target_pos)
		var delta: Vector2 = dir * min(distance, strength)# * retract_ratio
		if  distance > 0:
			global_position += delta
