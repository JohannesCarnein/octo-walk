shader_type canvas_item;

// How depleted the meter is in percent.
uniform float depletion_pct: hint_range(0.0, 1.0, 0.01) = 1.0;

uniform vec4 color: source_color = vec4(1.0);

uniform vec4 bg_wave_color: source_color = vec4(1.0);

uniform float wave_amplitude: hint_range(0.0, 0.1) = 0.05;
uniform float wave_frequency: hint_range(0.0, 20.0) = 5.0;
uniform float wave_scroll_speed: hint_range(0.0, 50.0) = 1.0;
uniform float bg_wave_offset = 1.0;


void fragment() {	
	float bg_wave_y = depletion_pct + sin(UV.x * wave_frequency * TAU + bg_wave_offset - TIME * wave_scroll_speed) * wave_amplitude;
    float wave_y = depletion_pct + sin(UV.x * wave_frequency * TAU + TIME * wave_scroll_speed) * wave_amplitude;
	
    if (UV.y >= wave_y) {
        // Color area below wave
        COLOR.rgb = color.rgb;
    } else if (UV.y >= (bg_wave_y - 0.002)) { // Offset the wave a bit to the top
        // Desaturate the wave behind
        COLOR.rgb = bg_wave_color.rgb;
    } else {
        COLOR = vec4(0.0);
    }
}
