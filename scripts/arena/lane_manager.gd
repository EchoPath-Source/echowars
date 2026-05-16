extends Node2D

# Canonical arena helper for the Echo Wars mobile board.
# The deploy regions are VEIL / CENTER_NODE / FIELD, but the Center Node is a
# contested convergence/control zone, not a normal third lane.

enum Lane { VEIL, CENTER_NODE, FIELD }

const ARENA_WIDTH: float = 720.0
const ARENA_HEIGHT: float = 1920.0

const VEIL_X: float = 180.0
const CENTER_X: float = 360.0
const FIELD_X: float = 540.0

const ENEMY_KING_Y: float = 120.0
const ENEMY_ANCHOR_Y: float = 220.0
const PLAYER_ANCHOR_Y: float = 1700.0
const PLAYER_KING_Y: float = 1800.0

const PLAYER_SPAWN_Y: float = 1640.0
const ENEMY_SPAWN_Y: float = 280.0

const CENTER_NODE_POS: Vector2 = Vector2(360.0, 960.0)
const CENTER_NODE_RADIUS: float = 96.0
const CONVERGENCE_APPROACH_OFFSET_Y: float = 260.0
const PRESSURE_EXIT_OFFSET_Y: float = 360.0

signal center_captured(team: String)

var center_controller: String = "neutral"

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	_draw_pressure_board()

func get_lane_x(lane: int) -> float:
	match lane:
		Lane.VEIL:
			return VEIL_X
		Lane.FIELD:
			return FIELD_X
		_:
			return CENTER_X

func get_spawn_pos(lane: int, is_player: bool) -> Vector2:
	return Vector2(get_lane_x(lane), PLAYER_SPAWN_Y if is_player else ENEMY_SPAWN_Y)

func get_anchor_pos(lane: int, is_player_anchor: bool) -> Vector2:
	var y := PLAYER_ANCHOR_Y if is_player_anchor else ENEMY_ANCHOR_Y
	if lane == Lane.CENTER_NODE:
		y = PLAYER_KING_Y if is_player_anchor else ENEMY_KING_Y
	return Vector2(get_lane_x(lane), y)

func get_enemy_king_pos(is_player_owned: bool) -> Vector2:
	return Vector2(CENTER_X, ENEMY_KING_Y if is_player_owned else PLAYER_KING_Y)

func get_macro_route_points(lane: int, is_player_owned: bool, start_pos: Vector2) -> Array[Vector2]:
	# Side pressure lanes bend into the Center Node convergence zone, then peel
	# toward enemy-side pressure. CENTER_NODE is a contested area, not a straight
	# third rail behind the anchors.
	var route: Array[Vector2] = [start_pos]

	if lane == Lane.CENTER_NODE:
		route.append(CENTER_NODE_POS)
		route.append(_get_center_node_pressure_exit(is_player_owned))
	else:
		route.append(_get_convergence_approach(lane, is_player_owned))
		route.append(CENTER_NODE_POS)
		route.append(_get_pressure_exit(lane, is_player_owned))

	route.append(get_enemy_king_pos(is_player_owned))
	return route

func get_lane_from_screen_pos(screen_x: float) -> int:
	if screen_x < 270.0:
		return Lane.VEIL
	elif screen_x > 450.0:
		return Lane.FIELD
	return Lane.CENTER_NODE

func _get_convergence_approach(lane: int, is_player_owned: bool) -> Vector2:
	var y_offset := CONVERGENCE_APPROACH_OFFSET_Y if is_player_owned else -CONVERGENCE_APPROACH_OFFSET_Y
	return Vector2(get_lane_x(lane), CENTER_NODE_POS.y + y_offset)

func _get_pressure_exit(lane: int, is_player_owned: bool) -> Vector2:
	var exit_lane := _get_opposite_pressure_lane(lane)
	var y_offset := -PRESSURE_EXIT_OFFSET_Y if is_player_owned else PRESSURE_EXIT_OFFSET_Y
	return Vector2(get_lane_x(exit_lane), CENTER_NODE_POS.y + y_offset)

func _get_center_node_pressure_exit(is_player_owned: bool) -> Vector2:
	# Temporary center deploy behavior: units still contest the node first, then
	# leave through a side-pressure vector so Center Node does not read as a lane.
	var exit_lane := Lane.FIELD if is_player_owned else Lane.VEIL
	var y_offset := -PRESSURE_EXIT_OFFSET_Y if is_player_owned else PRESSURE_EXIT_OFFSET_Y
	return Vector2(get_lane_x(exit_lane), CENTER_NODE_POS.y + y_offset)

func _get_opposite_pressure_lane(lane: int) -> int:
	return Lane.FIELD if lane == Lane.VEIL else Lane.VEIL

func _draw_pressure_board() -> void:
	_draw_arena_frame()
	_draw_pressure_routes()
	_draw_anchors()
	_draw_center_node()

func _draw_arena_frame() -> void:
	var board_rect := Rect2(Vector2(48.0, 72.0), Vector2(ARENA_WIDTH - 96.0, ARENA_HEIGHT - 144.0))
	draw_rect(board_rect, Color(0.05, 0.07, 0.12, 0.42), true)
	draw_rect(board_rect, Color(0.28, 0.44, 0.62, 0.45), false, 3.0)
	draw_line(Vector2(72.0, CENTER_NODE_POS.y), Vector2(ARENA_WIDTH - 72.0, CENTER_NODE_POS.y), Color(0.55, 0.7, 0.85, 0.25), 2.0)

func _draw_pressure_routes() -> void:
	var player_veil := get_macro_route_points(Lane.VEIL, true, get_spawn_pos(Lane.VEIL, true))
	var player_field := get_macro_route_points(Lane.FIELD, true, get_spawn_pos(Lane.FIELD, true))
	var enemy_veil := get_macro_route_points(Lane.VEIL, false, get_spawn_pos(Lane.VEIL, false))
	var enemy_field := get_macro_route_points(Lane.FIELD, false, get_spawn_pos(Lane.FIELD, false))

	_draw_route_curve(player_veil, Color(0.35, 0.68, 1.0, 0.5), 6.0)
	_draw_route_curve(player_field, Color(0.35, 0.68, 1.0, 0.5), 6.0)
	_draw_route_curve(enemy_veil, Color(1.0, 0.36, 0.36, 0.42), 5.0)
	_draw_route_curve(enemy_field, Color(1.0, 0.36, 0.36, 0.42), 5.0)

func _draw_route_curve(points: Array[Vector2], color: Color, width: float) -> void:
	var smoothed := _build_route_preview_curve(points)
	if smoothed.size() >= 2:
		draw_polyline(smoothed, color, width, true)

func _build_route_preview_curve(points: Array[Vector2]) -> PackedVector2Array:
	var smoothed := PackedVector2Array()
	if points.size() < 2:
		return smoothed

	if points.size() < 5:
		for point in points:
			smoothed.append(point)
		return smoothed

	smoothed.append_array(_get_quadratic_segment(points[0], points[1], points[2], 12, false))
	smoothed.append_array(_get_quadratic_segment(points[2], points[3], points[4], 12, true))
	return smoothed

func _get_quadratic_segment(start: Vector2, control: Vector2, end: Vector2, steps: int, skip_first: bool) -> PackedVector2Array:
	var segment := PackedVector2Array()
	for index in range(steps + 1):
		if skip_first and index == 0:
			continue

		var t := float(index) / float(steps)
		var inverse_t := 1.0 - t
		var point := (inverse_t * inverse_t * start) + (2.0 * inverse_t * t * control) + (t * t * end)
		segment.append(point)
	return segment

func _draw_anchors() -> void:
	_draw_anchor(get_anchor_pos(Lane.VEIL, true), Color(0.2, 0.55, 0.95, 0.92), "Veil")
	_draw_anchor(get_anchor_pos(Lane.FIELD, true), Color(0.2, 0.55, 0.95, 0.92), "Field")
	_draw_anchor(get_anchor_pos(Lane.VEIL, false), Color(0.95, 0.2, 0.22, 0.92), "Veil")
	_draw_anchor(get_anchor_pos(Lane.FIELD, false), Color(0.95, 0.2, 0.22, 0.92), "Field")
	draw_circle(get_anchor_pos(Lane.CENTER_NODE, true), 30.0, Color(0.2, 0.55, 0.95, 0.55))
	draw_circle(get_anchor_pos(Lane.CENTER_NODE, false), 30.0, Color(0.95, 0.2, 0.22, 0.55))

func _draw_anchor(pos: Vector2, color: Color, label: String) -> void:
	draw_circle(pos, 42.0, color)
	draw_circle(pos, 46.0, Color(0.9, 0.95, 1.0, 0.35), false, 3.0)
	draw_string(ThemeDB.fallback_font, pos + Vector2(-34.0, 70.0), label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 24.0, Color(0.86, 0.92, 1.0, 0.84))

func _draw_center_node() -> void:
	# Draw the Center Node last so it reads as the contested convergence zone in
	# front of the pressure lanes, not as a hidden middle lane anchor.
	draw_circle(CENTER_NODE_POS, CENTER_NODE_RADIUS, Color(0.75, 0.58, 1.0, 0.24))
	draw_arc(CENTER_NODE_POS, CENTER_NODE_RADIUS, 0.0, TAU, 72, Color(0.92, 0.82, 1.0, 0.92), 5.0, true)
	draw_circle(CENTER_NODE_POS, 18.0, Color(0.95, 0.9, 1.0, 0.96))
	draw_string(ThemeDB.fallback_font, CENTER_NODE_POS + Vector2(-78.0, -CENTER_NODE_RADIUS - 18.0), "Center Node", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 28.0, Color(0.95, 0.9, 1.0, 0.95))
