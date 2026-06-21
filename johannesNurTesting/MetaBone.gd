class_name MetaBone
extends Bone2D

@export var shape_override: Shape2D
@export var rotation_stiffness: float = 100000.0
@export var rotation_damping: float = 120.0
@export var stiffness_mult: float = 1
@export var mass: float = 1

@export var constant_force: Vector2 = Vector2.ZERO

@export var layer: int = 1

@export var position_stiffness: float = 3
@export var position_damping: float = 3.0

@export var should_draw: bool = true

@export var override_target_rot: Vector2
@export var angula_limit_lower: float
@export var angula_limit_upper: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
	
func _draw() -> void:
	if should_draw:
		draw_set_transform((Vector2(0.5, 0).rotated(get_bone_angle()) * get_length()), get_bone_angle() - deg_to_rad(90), Vector2.ONE)
		get_shape().draw(get_canvas_item(), stiffness_to_color(get_rotation_stiffness()))
	
func stiffness_to_color(stiffness: float) -> Color:
	return lerp(Color.GREEN, Color.RED, remap(stiffness, 0, 200000, 0, 1))
	
func get_rotation_stiffness() -> float:
	return rotation_stiffness * stiffness_mult
	
func get_shape() -> Shape2D:
	if shape_override != null:
		return shape_override
	return get_default_shape()
	
func get_default_shape() -> CapsuleShape2D:
	var shape := CapsuleShape2D.new()
	shape.radius = get_length()/7
	shape.height = get_length() - 3
	return shape
	
func get_tail_pos() -> Vector2:
	return global_position
	
func get_head_pos() -> Vector2:
	return get_tail_pos() + (Vector2.RIGHT * get_length()).rotated(get_bone_angle())
	
func get_center_pos() -> Vector2:
	return (get_tail_pos() + get_head_pos()) / 2
	
func get_tail_to_head_dir() -> Vector2:
	return get_tail_pos().direction_to(get_head_pos())
