shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 0.5;
uniform float velocity : hint_range(0.0, 10.0) = 1.0;
uniform vec4 fog_color : source_color = vec4(0.7, 0.7, 0.7, 0.3);
uniform vec4 direction = vec4(0.0, 0.0, 0.0, 0.0);
uniform float granularity : hint_range(1.0, 50.0) = 10.0;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 random2(vec2 st){
    st = vec2(dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)));
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

// Gradient Noise
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;

    // Add multiple layers of noise
    for(int i = 0; i < 5; i++) {
        value += amplitude * noise(st * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void fragment() {
    vec2 uv = UV;
    vec2 movement = vec2(0.0);
    movement += vec2(0.0, 1.0) * direction.x;
    movement += vec2(0.0, -1.0) * direction.y;
    movement += vec2(-1.0, 0.0) * direction.z;
    movement += vec2(1.0, 0.0) * direction.w;

    // Add movement over time
    uv += movement * TIME * velocity;

    // Generate smooth fog pattern
    float noise_value = fbm(uv * granularity);
    noise_value = smoothstep(0.0, 1.0, noise_value * 0.5 + 0.5);

    float alpha = noise_value * intensity * fog_color.a;
    COLOR = vec4(fog_color.rgb, alpha);
}