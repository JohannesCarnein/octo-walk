class_name WeaponSpawner
extends Node2D
## Continuously shoots weapons at the player

@export var min_weapon_spawn_time_s := 10.0
@export var max_weapon_spawn_time_s := 20.0

const _weapon_scene := preload("uid://d2otmjno8y78b")

func initialize(player: PlayerController) -> void:
	# reparent to follow the player
	reparent(player)

func start() -> void:
	await get_tree().create_timer(max_weapon_spawn_time_s).timeout
	_spawn_weapon_and_wait()

func _spawn_weapon_and_wait() -> void:
	var weapon := _weapon_scene.instantiate() as WeaponLinear
	weapon.shoot_at_target(get_parent().global_position)

	await get_tree().create_timer(
		randf_range(max_weapon_spawn_time_s, max_weapon_spawn_time_s)).timeout
	_spawn_weapon_and_wait()
