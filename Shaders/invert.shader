shader_type canvas_item;

uniform bool invertColor;

void fragment() {
	vec4 spriteTexture = texture(TEXTURE, UV);
	vec4 screenTexture = texture(SCREEN_TEXTURE, SCREEN_UV);
	if (invertColor) {
		COLOR.rgb = vec3(1.0) - (screenTexture.rgb * spriteTexture.a + spriteTexture.rgb);
	} else {
		COLOR.rgb = texture(TEXTURE, UV).rgb;
	}
}