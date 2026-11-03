
shader_type canvas_item;
#include "res://source/shaders/outline.gdshaderinc"

uniform sampler2D gradient : filter_nearest;
uniform vec4 outline = vec4(0.,0.,0.,1.);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = texture(gradient,vec2(COLOR.r,0.)).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
