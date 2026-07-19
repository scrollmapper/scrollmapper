shader_type canvas_item;

uniform vec4 edge_color : source_color = vec4(
    0.0,
    0.025,
    0.055,
    1.0
);

uniform float edge_darkness : hint_range(0.0, 1.0, 0.01) = 0.20;
uniform float radius : hint_range(0.0, 1.0, 0.01) = 0.42;
uniform float softness : hint_range(0.01, 1.0, 0.01) = 0.40;

void fragment() {
    vec2 centered_uv = UV - vec2(0.5);

    // Maintain the vignette shape on widescreen displays.
    centered_uv.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

    float distance_from_center = length(centered_uv);

    float vignette = smoothstep(
        radius,
        radius + softness,
        distance_from_center
    );

    COLOR = vec4(
        edge_color.rgb,
        vignette * edge_darkness * edge_color.a
    );
}