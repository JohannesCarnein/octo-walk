extends Node

@export var fade_in_out_duration := 0.5

@export var cutscene: PackedScene
@export var menu: PackedScene
@export var game: PackedScene
@export var end_screen: PackedScene

@onready var player1: AudioStreamPlayer = %AudioStreamPlayer1
@onready var player2: AudioStreamPlayer = %AudioStreamPlayer2

@onready var screen_fade: ColorRect = %ScreenFade

var current_screen: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.play_music_requested.connect(_on_play_music_requested)
	show_cutscene()

func show_cutscene() -> void:
	var cutscene_controller := cutscene.instantiate() as CutsceneController
	transition_to(cutscene_controller)
	cutscene_controller.finished.connect(show_menu, CONNECT_ONE_SHOT)

func show_menu() -> void:
	var menu_controller := menu.instantiate() as MenuController
	transition_to(menu_controller)
	menu_controller.start_game_requested.connect(show_game, CONNECT_ONE_SHOT)

func show_game() -> void:
	var game_controller := game.instantiate() as GameController
	transition_to(game_controller)
	game_controller.finished.connect(show_end_screen, CONNECT_ONE_SHOT)

func show_end_screen() -> void:
	var end_screen_controller := end_screen.instantiate() as EndScreenController
	transition_to(end_screen_controller)
	end_screen_controller.finished.connect(show_menu, CONNECT_ONE_SHOT)

func transition_to(scene: Node) -> void:
	if is_instance_valid(current_screen):
		screen_fade.show()
		var tween_in := create_tween()
		tween_in.tween_property(screen_fade, "modulate", Color.BLACK, fade_in_out_duration * 0.5)
		await tween_in.finished
		current_screen.queue_free()
	var tween_out := create_tween()
	add_child(scene)
	tween_out.tween_property(screen_fade, "modulate", Color.TRANSPARENT, fade_in_out_duration * 0.5)
	current_screen = scene
	await tween_out.finished
	screen_fade.hide()

var _current_player: AudioStreamPlayer
func _on_play_music_requested(music: AudioStream) -> void:
	if is_instance_valid(_current_player) and music == _current_player.stream:
		return
	if _current_player == player1:
		switch_to_player(player2, music)
	else:
		switch_to_player(player1, music)

func switch_to_player(new_player: AudioStreamPlayer, music: AudioStream) -> void:
	var tween := create_tween()
	if is_instance_valid(_current_player) and _current_player.playing:
		tween.tween_property(_current_player, "volume_linear", 0.0, 0.3)
	new_player.stream = music
	new_player.play()
	tween.tween_property(new_player, "volume_linear", 1.0, 0.3)

	_current_player = new_player
