class_name ActiveRagdoll
extends Node2D

@onready var skeleton: Skeleton2D = %Skeleton2D
@onready var ragdoll: Node2D

var bone_to_body: Dictionary[Bone2D, ActiveRigidBody] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ragdoll = Node2D.new()
	add_child(ragdoll)
	build_ragdoll()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func build_ragdoll() -> void:
	for child in skeleton.get_children():
		if child is Bone2D:
			_process_bone(child, null)

func _process_bone(bone: Bone2D, parent_body: ActiveRigidBody) -> void:
	var body := ActiveRigidBody.new(bone)
	bone_to_body[bone] = body

	if parent_body == null:
		ragdoll.add_child(body)
	else:
		parent_body.add_child(body)
		body.global_position = bone.global_position
		body.position += Vector2(0, bone.get_length() / 2.0)
		_connect_bodies(parent_body, body)

	for child in bone.get_children():
		if child is Bone2D:
			_process_bone(child, body)

func _connect_bodies(parent_body: ActiveRigidBody, child_body: ActiveRigidBody) -> void:
	var joint := RapierPinJoint2D.new()
	parent_body.add_child(joint)
	joint.global_position = child_body.bone.global_position
	joint.node_a = parent_body.get_path()
	joint.node_b = child_body.get_path()
