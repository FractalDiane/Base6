shader_type canvas_item;

uniform bool invertColor;

void fragment() {
	if (invertColor) {
		COLOR.rgb = vec3(1.0) - texture(TEXTURE, UV).rgb;
	} else {
		COLOR.rgb = texture(TEXTURE, UV).rgb;
	}
}