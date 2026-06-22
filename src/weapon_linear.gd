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


func shoot_direction(direction: Vector2) -> void:
	rotation = Vector2.UP.angle_to(direction)
	velocity = direction.normalized() * speed

func _process(delta: float) -> void:
	position += velocity * delta


func _on_area_entered(area: Area2D) -> void:
	if area is PlayerArea:
		print("TODO apply impulse")
	queue_free()
	# TODO
