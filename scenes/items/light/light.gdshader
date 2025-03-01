shader_type canvas_item;
render_mode blend_premul_alpha, unshaded;

uniform float alpha = 0;
uniform float light_intensity = 0.3;
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius = 0.3;
uniform float fade_width = 0.2;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 background_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    float factor = 1.0 - alpha;
    if (factor < 0.001) {
        factor = 0.001;
    }

    vec3 base_color = background_color.rgb / factor;
    base_color = clamp(base_color, 0.0, 1.0);

    float dist = distance(UV, center);
    float radial_factor = 1.0 - smoothstep(radius, radius + fade_width, dist);

    float light_factor = radial_factor * light_intensity;

    COLOR = vec4(base_color * light_factor, light_factor);
}