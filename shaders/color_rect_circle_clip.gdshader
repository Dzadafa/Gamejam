shader_type canvas_item;

uniform float radius : hint_range(0.0, 0.5) = 0.01;
uniform float smoothing : hint_range(0.0, 0.1) = 0.01;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float dist = distance(UV, vec2(0.5, 0.5));
	
	float circle_alpha = 1.0 - smoothstep(radius - smoothing, radius, dist);
	
	COLOR.a *= circle_alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
