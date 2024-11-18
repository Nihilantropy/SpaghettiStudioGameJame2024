shader_type canvas_item;

uniform vec4 background_color : source_color; // Colore di sfondo
uniform vec4 circle_color : source_color; // Colore del cerchio
uniform float circle_radius : hint_range(0.0, 1.0); // Raggio del cerchio
uniform vec2 circle_position; // Posizione del cerchio (normale: [0, 1])

void fragment() {
    // Coordinate normalizzate (0-1)
    vec2 uv = UV;

    // Centro del cerchio in coordinate UV
    vec2 center = circle_position;

    // Calcola la distanza dall'UV al centro del cerchio
    float dist = distance(uv, center);

    // Definisci il colore in base alla distanza dal centro del cerchio
    vec4 color = background_color;
    if (dist < circle_radius) {
        color = mix(circle_color, background_color, smoothstep(circle_radius - 0.01, circle_radius, dist));
    }

    // Output del colore
    COLOR = color;
}