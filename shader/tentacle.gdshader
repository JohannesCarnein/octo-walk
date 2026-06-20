shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 100.0) = 20.0;
uniform float frequency : hint_range(0.0, 20.0) = 6.0;
uniform float speed : hint_range(0.0, 10.0) = 2.0;

void vertex() {
    float tip_factor = UV.y;

    // Smooth falloff so the base stays still
    float weight = pow(tip_factor, 2.0);

    // Wave phase varies along the tentacle
    float wave = sin(TIME * speed + tip_factor * frequency);

    // Move horizontally
    VERTEX.x += wave * amplitude * weight;
}
