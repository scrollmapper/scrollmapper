shader_type canvas_item;
render_mode unshaded, blend_mix;


// Overall opacity of the atmospheric layer.
uniform float glow_strength : hint_range(0.0, 1.0) = 0.65;


// Slow evolution of the cloud field.
uniform float cycle_speed : hint_range(0.0, 0.5) = 0.05;


// Approximate cloud size in screen pixels.
uniform float cloud_size : hint_range(10.0, 300.0) = 80.0;


// Controls the softness between clear and clouded sections.
uniform float cloud_softness : hint_range(0.01, 0.4) = 0.18;


// Prevents the atmospheric line from becoming completely invisible.
uniform float minimum_visibility : hint_range(0.0, 1.0) = 0.12;


// Optional variation between connections.
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

	result += noise(position) * 0.57;

	position = position * 2.03 + vec2(3.7, 7.1);
	result += noise(position) * 0.29;

	position = position * 2.01 + vec2(8.3, 2.8);
	result += noise(position) * 0.14;

	return result;
}

varying vec2 world_position;

void vertex() {
	world_position = (
		MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)
	).xy;
}

void fragment() {
	/*
		COLOR preserves the Line2D's assigned connection color.
	*/
	vec4 base = COLOR;

	float animation_time =
		TIME * cycle_speed + phase_offset;

	/*
		Screen coordinates create an ambient cloud field through
		which the connection appears to pass.

		There is no fixed start-to-end movement.
	*/
	vec2 cloud_position =
		world_position / cloud_size;

	vec2 first_wander = vec2(
		sin(animation_time * 0.73),
		cos(animation_time * 0.61)
	) * 1.7;

	vec2 second_wander = vec2(
		cos(animation_time * 0.43),
		sin(animation_time * 0.57)
	) * 2.1;

	float first_cloud = cloud_noise(
		cloud_position + first_wander
	);

	float second_cloud = cloud_noise(
		cloud_position * 0.63
		+ second_wander
		+ vec2(13.7, 4.3)
	);

	float cloud = mix(
		first_cloud,
		second_cloud,
		0.35
	);

	float visibility = smoothstep(
		0.50 - cloud_softness,
		0.50 + cloud_softness,
		cloud
	);

	/*
		Keep a minimum atmospheric trace instead of allowing
		the glow layer to become completely blank.
	*/
	visibility = mix(
		minimum_visibility,
		1.0,
		visibility
	);

	base.a *= visibility * glow_strength;

	COLOR = base;
}