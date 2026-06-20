extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q:
			play_anim("MoveL")
		if event.keycode == KEY_W:
			play_anim("MoveR")
			
func play_anim(anim_name: String) -> void:
	%AnimationPlayer.play(anim_name)
