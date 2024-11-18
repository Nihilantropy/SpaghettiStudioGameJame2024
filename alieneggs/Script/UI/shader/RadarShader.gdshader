shader_type canvas_item;

uniform vec2 noise_scale : hint_range(0, 10) = vec2(1, 1); // Scale of the noise
uniform float refraction_strength : hint_range(0.0, 1.0) = 0.2; // Distortion amount
uniform float transparency : hint_range(0.0, 1.0) = 0.8; // Opacity of the glass
uniform vec3 tint_color : hint_color = vec3(0.5, 0.8, 1.0); // Tint of the glass

void fragment() {
    // Screen UV coordinates
    vec2 screen_uv = SCREEN_UV;

    // Noise distortion
    vec2 noise_uv = UV * noise_scale;
    vec2 distortion = texture(noise_texture, noise_uv).rg - 0.5;
    distortion *= refraction_strength;

    // Refraction effect
    vec4 refracted_color = texture(SCREEN_TEXTURE, screen_uv + distortion);

    // Glass tint
    vec3 final_color = mix(refracted_color.rgb, tint_color, 0.2);

    // Output with transparency
    COLOR = vec4(final_color, transparency);
}
