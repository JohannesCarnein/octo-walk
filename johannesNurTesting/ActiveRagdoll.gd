class_name ActiveRagdoll
extends Node2D

signal on_impact(impact_strength: float)

@onready var skeleton: Skeleton2D = %Skeleton2D
@onready var ragdoll: Node2D

var bone_to_body: Dictionary[Bone2D, ActiveRigidBody] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ragdoll = Node2D.new()
	add_child(ragdoll)
	build_ragdoll()

func build_ragdoll() -> void:
	for child in skeleton.get_children():
		if child is MetaBone:
			_process_bone(child, null)

func _process_bone(bone: MetaBone, parent_body: ActiveRigidBody) -> void:
	var body := ActiveRigidBody.new(bone, skeleton)
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
	return com / i
