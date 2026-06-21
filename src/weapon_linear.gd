class_name WeaponLinear
extends Node2D
## Weapon that flies in a straight line

@export var speed := 10.0
@export var _variations: Array[Sprite2D] = []

@onready var hitbox: Area2D = %Hitbox

var velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_variations.pick_random().show()
	hitbox.area_entered.connect(_on_area_entered)


func shoot_at_target(global_target_position: Vector2) -> void:
	rotation = Vector2.UP.angle_to_point(global_target_position)
	velocity = Vector2.UP * speed


func _process(delta: float) -> void:
	position += velocity * delta


func _on_area_entered(area: Area2D) -> void:
	if area is PlayerArea:
		print("TODO apply impulse")
	else:
		printt("Weapon entered area", area)
	queue_free()
	# TODO
