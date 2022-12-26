shader_type canvas_item;

// Gonkee's water shader for Godot 3 - full tutorial https://youtu.be/uhMAHpV_cDg
// If you use this shader, I would prefer if you gave credit to me and my channel

uniform vec4 blue_tint : hint_color;
uniform float edge_lower ;
uniform vec2 sprite_scale;
uniform float scale_x = 0.67;
uniform float per =0.9;
uniform float sv=1.0;
uniform float nas =0.3;
uniform float sp1;
uniform float sp2;
uniform float sp3;
uniform float sp4;
uniform float zatem;
uniform float zatem1;
uniform float pena;
uniform float wave_sp1;
uniform float wave_sp2;
uniform float wave_sp3;
uniform float cv_p;
float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(12.9898*wave_sp1, 78.233*wave_sp2)))* 43758.5453123);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

void fragment(){
	
	vec2 noisecoord1 = UV * sprite_scale * scale_x;
	vec2 noisecoord2 = UV * sprite_scale * scale_x + 40.0;
	
	vec2 motion1 = vec2(TIME * sp1, TIME * sp2);
	vec2 motion2 = vec2(TIME * sp3, TIME * sp4);
	
	vec2 distort1 = vec2(noise(noisecoord1 + motion1), noise(noisecoord2 + motion1)) - vec2(0.7);
	vec2 distort2 = vec2(noise(noisecoord1 + motion2), noise(noisecoord2 + motion2)) - vec2(0.4);
	
	vec2 distort_sum = (distort1 + distort2) / 60.0;
	
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV + distort_sum, 0.4);
	
	color = mix(color, blue_tint, nas);
	color.rgb = mix(vec3(zatem1), color.rgb, zatem);
	
	float near_top = (UV.y/2.0 + distort_sum.y) / (pena / sprite_scale.y);
	near_top = clamp(near_top, cv_p, 1.0);
	near_top = sv - near_top;
	
	color = mix(color, vec4(1.0), near_top);
	
	
	float edge_upper = edge_lower + per;
	
	if(near_top > edge_lower){
		color.a = 0.0;
		
		if(near_top < edge_upper){
			color.a = (edge_upper - near_top) / (edge_upper - edge_lower);
		}
	}
	
	COLOR = color;
}