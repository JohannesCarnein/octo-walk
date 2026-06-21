@tool
extends Node2D

signal depleted

@onready var _meter: Sprite2D = %Meter

@export_range(0.0, 1.0) var fill_pct := 1.0:
	set = set_fill

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	fill_pct = 1.0

func set_fill(value: float) -> void:
	fill_pct = clampf(value, 0.0, 1.0)
	if not is_inside_tree(): await ready
	(_meter.material as ShaderMaterial).set_shader_parameter("depletion_pct", 1.0 - fill_pct)
	if fill_pct <= 0.0:
		depleted.emit()
