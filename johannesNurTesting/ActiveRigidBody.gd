class_name ActiveRigidBody
extends RapierRigidBody2D

signal on_impact(impact_strength: float)

@onready var _impact_vfx_scene:= preload("res://johannesNurTesting/impact_vfx.tscn")
var impact_vfx: ImpactVFX

@export var rotation_stiffness: float
@export var rotation_damping: float
@export var position_stiffness: float
@export var position_damping: float
@export var override_target_rot: Vector2

@export var angula_limit_lower: float
@export var angula_limit_upper: float

var bone: Bone2D
var skeleton: Skeleton2D
var collisionShape: CollisionShape2D
var remote_transform: RemoteTransform2D

var _mad: float = 5
var _mid: float = 1

var _mas: float = 1
var _mis: float = 0.2

var constant_force_bonus: Vector2 = Vector2.ZERO

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var contact_count = state.get_contact_count()
	for i in range(contact_count):
		var impulse = state.get_contact_impulse(i)
		var impact_strength = impulse.length()
		if impact_strength > 100.0:
			impact_vfx.impact(impact_strength, impulse.angle())
			emit_signal("on_impact", impact_strength)

func _init(b: MetaBone, skel: Skeleton2D) -> void:
	contact_monitor = true
	max_contacts_reported = 2
	bone = b
	name = bone.name
	rotation_stiffness = b.get_rotation_stiffness()
	rotation_damping = b.rotation_damping
	position_stiffness = b.position_stiffness
	position_damping = b.position_damping
	var col := CollisionShape2D.new()
	col.shape = b.get_shape()
	collisionShape = col
	mass = b.mass
	set_collision_layer_value(1, false)
	set_collision_layer_value(b.layer, true)
	remote_transform = RemoteTransform2D.new()
	constant_force_bonus = b.constant_force
	if b.override_target_rot:
		override_target_rot = b.override_target_rot
	if b.angula_limit_lower:
		if b.angula_limit_upper:
			angula_limit_lower = b.angula_limit_lower
			angula_limit_upper = b.angula_limit_upper
			

func register_as_follower_bone(b: Bone2D) -> void:
	remote_transform.remote_path = b.get_path()
	

func _ready() -> void:
	add_child(collisionShape)
	collisionShape.rotation = bone.get_bone_angle() + deg_to_rad(-90)
	add_child(remote_transform)
	impact_vfx = _impact_vfx_scene.instantiate()
	add_child(impact_vfx)
	add_constant_force(constant_force_bonus)



func _physics_process(delta: float) -> void:
	_follow_bone()

func _process(delta: float) -> void:
	queue_redraw()	

	
func get_damping_mult() -> float:
	return clamp(remap(angular_velocity, 0, 20, _mid, _mad), _mid, _mad)
	
func get_stiffness_mult() -> float:
	return clamp(remap(angular_velocity, 0, 20, _mas, _mis), _mis, _mas)
	
func _draw():
	debug_draw_target()
	#draw_set_transform(to_local(bone.global_position), -global_rotation, Vector2.ONE)
	#draw_string(ThemeDB.fallback_font, Vector2.ZERO, str(snapped(get_damping_mult(), 0.1)))

func _get_target_transform() -> Transform2D:
	return bone.global_transform

	
func _get_target_rotation() -> float:
	var local_rotation = bone.rotation
	if override_target_rot:
		return lerpf(local_rotation, to_local(override_target_rot).angle(), 0.8)

	return local_rotation
	
func _get_target_position() -> Vector2:
	return bone.global_position

func _follow_bone() -> void:
	var target_rot := _get_target_rotation()

	var rot_delta := wrapf(target_rot - rotation, -PI, PI)
	var torque := rot_delta * rotation_stiffness * get_stiffness_mult() - angular_velocity * rotation_damping * get_damping_mult()
	apply_torque(torque)
	
	var target_global_pos := _get_target_position()
	
	var pos_delta := target_global_pos - global_position
	var force := (pos_delta * position_stiffness * get_stiffness_mult()) - (linear_velocity * position_damping)
	
	apply_force(force)
	
	
func _get_target_tip_position() -> Vector2:
	return to_local(bone.global_position + Vector2(0, bone.get_length() / 2.0).rotated(deg_to_rad(180)))
	
func debug_draw_target() -> void:
	draw_circle(_get_target_tip_position(), 5, Color.RED)
