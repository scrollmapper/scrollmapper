shader_type canvas_item;
render_mode unshaded, blend_mix;


/*
	Tuned Scrollmapper scripture-node fog.

	Color: #3f5e7e
	These defaults reproduce the carefully balanced Inspector settings.
*/
uniform vec4 fog_color : source_color = vec4(
	0.247059,
	0.368627,
	0.494118,
	1.0
);


// Tuned appearance
uniform float fog_strength : hint_range(0.0, 0.5) = 0.5;
uniform float fog_reach : hint_range(0.02, 0.5) = 0.1;
uniform float fog_scale : hint_range(1.0, 12.0) = 5.908;
uniform float fog_softness : hint_range(0.01, 0.30) = 0.3;


// Tuned movement
uniform float fog_speed : hint_range(0.0, 0.1) = 0.06;
uniform float curl_strength : hint_range(0.0, 2.0) = 1.82;


// Optional variation between nodes
uniform float phase_offset = 0.0;


float random_value(vec2 position) {
	return fract(
		sin(dot(position, vec2(127.1, 311.7)))
		* 43758.5453
	);
}


float noise(vec2 position) {
	vec2 cell = floor(position);
	vec2 fraction = fract(position);

	fraction = fraction * fraction * (3.0 - 2.0 * fraction);

	float a = random_value(cell);
	float b = random_value(cell + vec2(1.0, 0.0));
	float c = random_value(cell + vec2(0.0, 1.0));
	float d = random_value(cell + vec2(1.0, 1.0));

	return mix(
		mix(a, b, fraction.x),
		mix(c, d, fraction.x),
		fraction.y
	);
}


float cloud_noise(vec2 position) {
	float result = 0.0;

	result += noise(position) * 0.55;

	position = position * 2.03 + vec2(3.7, 7.1);
	result += noise(position) * 0.30;

	position = position * 2.01 + vec2(8.3, 2.8);
	result += noise(position) * 0.15;

	return result;
}


float fog_from_edge(
	float tangent,
	float depth,
	float seed
) {
	float animation_time =
		TIME * fog_speed + phase_offset;

	/*
		Subtracting time from depth moves the visible formations
		from the edge toward the center.
	*/
	vec2 flow_position = vec2(
		tangent * fog_scale,
		(depth - animation_time) * fog_scale
	);

	/*
		A secondary noise field bends the primary fog formations,
		producing slow dry-ice curls instead of straight movement.
	*/
	vec2 curl = vec2(
		cloud_noise(flow_position * 0.55 + seed),
		cloud_noise(flow_position * 0.55 + seed + 13.7)
	);

	curl = (curl - vec2(0.5)) * curl_strength;

	float fog_noise = cloud_noise(
		flow_position + curl + seed
	);

	float cloud_shape = smoothstep(
		0.50 - fog_softness,
		0.50 + fog_softness,
		fog_noise
	);

	/*
		The fog is strongest at its source and disappears quickly
		as it moves inward.
	*/
	float inward_fade = 1.0 - smoothstep(
		0.0,
		fog_reach,
		depth
	);

	inward_fade *= inward_fade;

	/*
		Maintain a faint continuous vapor border while the larger
		formations move through it.
	*/
	float vapor = mix(
		0.08,
		1.0,
		cloud_shape
	);

	return vapor * inward_fade;
}


void fragment() {
	float left_fog = fog_from_edge(
		UV.y,
		UV.x,
		0.0
	);

	float right_fog = fog_from_edge(
		UV.y,
		1.0 - UV.x,
		17.3
	);

	float top_fog = fog_from_edge(
		UV.x,
		UV.y,
		31.7
	);

	float bottom_fog = fog_from_edge(
		UV.x,
		1.0 - UV.y,
		47.1
	);

	float fog = max(
		max(left_fog, right_fog),
		max(top_fog, bottom_fog)
	);

	float final_alpha = clamp(
		fog * fog_strength,
		0.0,
		1.0
	);

	/*
		The ColorRect contributes only colored vapor.
		Everything else remains transparent.
	*/
	COLOR = vec4(
		fog_color.rgb,
		final_alpha * fog_color.a
	);
}