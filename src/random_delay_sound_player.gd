extends AudioStreamPlayer

@export var _min_wait_time := 20.0
@export var _max_wait_time := 40.0

func _ready() -> void:
	_wait_and_play_athmo_sound()

func _wait_and_play_athmo_sound() -> void:
	var wait_time := randf_range(_min_wait_time, _max_wait_time)
	print("Waiting %s for next playback" % wait_time)
	await get_tree().create_timer(wait_time).timeout
	play()
	await finished
	_wait_and_play_athmo_sound()
