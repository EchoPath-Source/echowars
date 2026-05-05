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
const CENTER_NODE_RADIUS: float = 80.0

signal center_captured(team: String)

var center_controller: String = "neutral"

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
	# Layer 3 simple route: side-lane pressure bends through the Center Node zone,
	# then redirects toward the opposing king/anchor direction. This keeps the
	# prototype close to the rounded-X / convergence model without full pathfinding.
	var route: Array[Vector2] = [start_pos]

	if lane == Lane.CENTER_NODE:
		route.append(CENTER_NODE_POS)
	else:
		var bend_y := 1120.0 if is_player_owned else 800.0
		route.append(Vector2(get_lane_x(lane), bend_y))
		route.append(CENTER_NODE_POS)

	route.append(get_enemy_king_pos(is_player_owned))
	return route

func get_lane_from_screen_pos(screen_x: float) -> int:
	if screen_x < 270.0:
		return Lane.VEIL
	elif screen_x > 450.0:
		return Lane.FIELD
	return Lane.CENTER_NODE
