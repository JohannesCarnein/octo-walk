extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.splash_water.connect(_on_splash_water)


func _on_splash_water(a_lot: bool) -> void:
	emitting = true
