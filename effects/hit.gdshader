shader_type canvas_item;

uniform float hit_opacity = 0;
uniform float r = 1;
uniform float g = 1;
uniform float b = 1;

void fragment() {
	COLOR.rgb = texture(TEXTURE, UV).rgb * (1.0 - hit_opacity) + vec3(r, g, b) * hit_opacity;
	COLOR.a = texture(TEXTURE, UV).a;
}
