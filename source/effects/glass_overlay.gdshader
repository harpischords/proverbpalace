shader_type canvas_item;
render_mode blend_add;

#include "res://source/shaders/hsv.gdshaderinc"

instance uniform vec4 tile_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	vec3 hsv = rgb_to_hsv(COLOR.rgb);
	vec3 tile_color_hsv = rgb_to_hsv(tile_color.rgb);
	COLOR.a *= hsv.b;
	float untint = hsv.b*2.;
	hsv.b = mix(tile_color_hsv.b,1.,untint);
	hsv.r = tile_color_hsv.r;
	hsv.g = tile_color_hsv.g;
	COLOR.rgb = hsv_to_rgb(hsv);
	
	//COLOR = tile_color;
	//COLOR.a = 1.;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
