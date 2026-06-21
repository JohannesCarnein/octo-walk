class_name ImpactVFX
extends CPUParticles2D


func _init() -> void:
	emitting = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func impact(strength: float = 1, angle: float = 0, arc: float = PI, speed: float = 0.1, col: Color = Color.SKY_BLUE) -> void:
	var fac:float = remap(strength, 500, 2000, 0, 1)
	one_shot = true
	scale_amount_min = fac * 3
	color = Color.from_hsv(fmod(col.h + ((fac - 0.5) * 0.5), 1), col.s, col.v, col.a)
	scale_amount_max = scale_amount_min
	direction = Vector2.UP.rotated(angle)
	lifetime = speed
	emitting = true
