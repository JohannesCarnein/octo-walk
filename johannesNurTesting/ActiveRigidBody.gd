class_name ActiveRigidBody
extends RapierRigidBody2D

@export var position_stiffness: float = 0.0
@export var position_damping: float = 5.0
@export var rotation_stiffness: float = 80000.0
@export var rotation_damping: float = 20.0

var bone: Bone2D
var collisionShape: CollisionShape2D

func _init(b: Bone2D) -> void:
	bone = b
	name = bone.name
	var col := CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	shape.height = bone.get_length()
	shape.radius = 100 / shape.height
	col.shape = shape
	collisionShape = col

func _ready() -> void:
	add_child(collisionShape)


func _physics_process(delta: float) -> void:
	_follow_bone()

func _get_target_transform() -> Transform2D:
	return bone.global_transform
	
func _get_target_position() -> Vector2:
	return bone.global_position
	
func _get_target_rotation() -> float:
	return bone.rotation

func _follow_bone() -> void:
	var target_xform := _get_target_transform()
	var target_pos := target_xform.origin
	var target_rot := target_xform.get_rotation()

	var pos_delta := target_pos - global_position
	var force := pos_delta * position_stiffness - linear_velocity * position_damping
	apply_central_force(force)

	var rot_delta := wrapf(target_rot - rotation, -PI, PI)
	var torque := rot_delta * rotation_stiffness - angular_velocity * rotation_damping
	apply_torque(torque)
