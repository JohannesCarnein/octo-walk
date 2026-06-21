class_name ActiveRagdoll
extends Node2D

signal on_impact(impact_strength: float)

@onready var controll_skeleton: Skeleton2D = %Skeleton2D
@onready var character_mesh_holder:= %CharacterMeshHolder
var deform_skeleton: Skeleton2D
var ragdoll: Node2D

var bone_to_body: Dictionary[Bone2D, ActiveRigidBody] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deform_skeleton = controll_skeleton.duplicate()
	add_child(deform_skeleton)
	reparent_mesh()
	ragdoll = Node2D.new()
	add_child(ragdoll)
	build_ragdoll()
	setup_deform_skeleton()
	
func setup_deform_skeleton() -> void:
	for i in range(deform_skeleton.get_bone_count()):
		bone_to_body[controll_skeleton.get_bone(i)].register_as_follower_bone(deform_skeleton.get_bone(i))

func reparent_mesh() -> void:
	for polygon in character_mesh_holder.get_children():
		if polygon is Polygon2D:
			polygon.skeleton = deform_skeleton.get_path()
			for subpol in polygon.get_children():
				if subpol is Polygon2D:
					subpol.skeleton = deform_skeleton.get_path()

func build_ragdoll() -> void:
	for child in controll_skeleton.get_children():
		if child is MetaBone:
			_process_bone(child, null)

func _process_bone(bone: MetaBone, parent_body: ActiveRigidBody) -> void:
	var body := ActiveRigidBody.new(bone, controll_skeleton)
	bone_to_body[bone] = body

	if parent_body == null:
		ragdoll.add_child(body)
	else:
		parent_body.add_child(body)
		body.global_position = bone.get_center_pos()
		_connect_bodies(parent_body, body)
		

	for child in bone.get_children():
		if child is MetaBone:
			_process_bone(child, body)

func add_listener(body: ActiveRigidBody) -> void:
	body.connect("on_collision", handle_collision)

func handle_collision(impact_strength: float) -> void:
	emit_signal("on_impact", impact_strength)

func _connect_bodies(parent_body: ActiveRigidBody, child_body: ActiveRigidBody) -> void:
	var joint := RapierPinJoint2D.new()
	#joint.motor_position_damping = 1
	parent_body.add_child(joint)
	joint.global_position = child_body.bone.global_position
	joint.node_a = parent_body.get_path()
	joint.node_b = child_body.get_path()
	
func get_center_of_mass() -> Vector2:
	var com: Vector2 = Vector2.ZERO
	var furthes: float = 0
	var i: int = 0
	for body in bone_to_body.values():
		com += body.global_position
		if body.global_position.x > furthes:
			furthes = body.global_position.x
		i += 1
	var avr: Vector2 = com / i
	return lerp(avr, Vector2(furthes, avr.y), 0.7)
