class_name CutsceneController
extends Control

@export var slide_duration := 3.0

var scenes: Array[TextureRect] = []
var previous_slide: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is TextureRect:
			scenes.append(child)
			child.hide()

	show_slide(scenes.pop_front())

func show_slide(slide: TextureRect) -> void:
	if is_instance_valid(previous_slide):
		previous_slide.hide()
	slide.show()
	await get_tree().create_timer(slide_duration).timeout
	previous_slide = slide
	if not scenes.is_empty():
		show_slide(scenes.pop_front())
