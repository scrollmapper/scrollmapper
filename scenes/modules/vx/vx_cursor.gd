extends Line2D
class_name VXCursor


@export var size: Vector2 = Vector2(32.0, 32.0):
	set(value):
		size = value
		queue_redraw()


@export var reticle_color: Color = Color("#55C7F5"):
	set(value):
		reticle_color = value
		queue_redraw()


@export_range(1.0, 4.0, 0.5)
var line_width: float = 2.0:
	set(value):
		line_width = value
		queue_redraw()


@export_range(1.0, 6.0, 0.5)
var dot_radius: float = 2.5:
	set(value):
		dot_radius = value
		queue_redraw()


func _ready() -> void:
	clear_points()
	queue_redraw()


func _draw() -> void:
	var horizontal_radius := size.x * 0.5
	var vertical_radius := size.y * 0.5
	var inner_radius := dot_radius + 3.0

	# Horizontal arms
	draw_line(
		Vector2(-horizontal_radius, 0.0),
		Vector2(-inner_radius, 0.0),
		reticle_color,
		line_width,
		true
	)

	draw_line(
		Vector2(inner_radius, 0.0),
		Vector2(horizontal_radius, 0.0),
		reticle_color,
		line_width,
		true
	)

	# Vertical arms
	draw_line(
		Vector2(0.0, -vertical_radius),
		Vector2(0.0, -inner_radius),
		reticle_color,
		line_width,
		true
	)

	draw_line(
		Vector2(0.0, inner_radius),
		Vector2(0.0, vertical_radius),
		reticle_color,
		line_width,
		true
	)

	# Center dot
	draw_circle(
		Vector2.ZERO,
		dot_radius,
		reticle_color,
		true,
		-1.0,
		true
	)
