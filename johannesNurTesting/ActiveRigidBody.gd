class_name ActiveRigidBody
extends RapierRigidBody2D

signal on_impact(impact_strength: float)

@onready var _impact_vfx_scene:= preload("res://johannesNurTesting/impact_vfx.tscn")
var impact_vfx: ImpactVFX

@export var rotation_stiffness: float = 100000.0
@export var rotation_damping: float = 30.0
@export var position_stiffness: float = 0.0
@export var position_damping: float = 1.0

var bone: Bone2D
var skeleton: Skeleton2D
var collisionShape: CollisionShape2D

var _mad: float = 5
var _mid: float = 1

var _mas: float = 1
var _mis: float = 0.2

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var contact_count = state.get_contact_count()
	for i in range(contact_count):
		var impulse = state.get_contact_impulse(i)
		var impact_strength = impulse.length()
		if impact_strength > 600.0:
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
	
	

func _ready() -> void:
	add_child(collisionShape)
	impact_vfx = _impact_vfx_scene.instantiate()
	add_child(impact_vfx)

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
	draw_set_transform(to_local(bone.global_position), -global_rotation, Vector2.ONE)
	draw_string(ThemeDB.fallback_font, Vector2.ZERO, str(snapped(get_damping_mult(), 0.1)))

func _get_target_transform() -> Transform2D:
	return bone.global_transform
	
func _get_target_tip_position() -> Vector2:
	return Vector2(0, bone.get_length() / 2.0).rotated(bone.get_bone_angle())
	
func _get_target_rotation() -> float:
	var local_rotation = bone.rotation
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
	
func debug_draw_target() -> void:
	draw_circle(_get_target_tip_position(), 5, Color.RED)
