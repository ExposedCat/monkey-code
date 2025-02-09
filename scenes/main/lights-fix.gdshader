shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    screen_color.rgb = clamp(screen_color.rgb, 0.0, 0.3);
    COLOR = screen_color;
}
