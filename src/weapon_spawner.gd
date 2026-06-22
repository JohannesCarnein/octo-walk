@tool
class_name WeaponSpawner
extends Node2D
## Continuously shoots weapons at the player

@export var min_weapon_spawn_time_s := 10.0
@export var max_weapon_spawn_time_s := 20.0

@export var spawn_area_height := 50.0:
    set(v): spawn_area_height = v; queue_redraw()

@onready var despawn_area: Area2D = %WeaponDespawnArea

var __running := false

const _weapon_scene := preload("uid://d2otmjno8y78b")

func _ready() -> void:
    despawn_area.area_entered.connect(_on_despawn_area_entered)
    queue_redraw()

func start() -> void:
    __running = true
    await get_tree().create_timer(max_weapon_spawn_time_s).timeout
    _spawn_weapon_and_wait()

func stop() -> void:
    __running = false

func _draw() -> void:
    if not Engine.is_editor_hint():
        return
    draw_line(Vector2(0.0, -spawn_area_height * 0.5), Vector2(0.0, spawn_area_height * 0.5), Color.BLACK, -1)

func _spawn_weapon_and_wait() -> void:
    if not __running:
        return
    var weapon := _weapon_scene.instantiate() as WeaponLinear
    add_child(weapon)
    weapon.position.y += randf_range(-0.5, 0.5) * spawn_area_height
    weapon.shoot_direction(Vector2.LEFT)
    print("spawn weapoon")

    await get_tree().create_timer(
        randf_range(min_weapon_spawn_time_s, max_weapon_spawn_time_s)).timeout
    _spawn_weapon_and_wait()

func _on_despawn_area_entered(area: Area2D) -> void:
    if area.get_parent() is WeaponLinear:
        area.get_parent().queue_free()
