extends Node2D

signal center_captured(team: String)

enum Lane { VEIL, CENTER_NODE, FIELD }

const ARENA_WIDTH: float = 720.0
const ARENA_HEIGHT: float = 1920.0

const VEIL_X: float = 180.0
const CENTER_X: float = 360.0
const FIELD_X: float = 540.0

const PLAYER_SPAWN_Y: float = 1700.0
const ENEMY_SPAWN_Y: float = 220.0

const PLAYER_KING_Y: float = 1800.0
const ENEMY_KING_Y: float = 120.0

const CENTER_NODE_POS: Vector2 = Vector2(360.0, 960.0)
const CENTER_NODE_RADIUS: float = 80.0

var center_controller: String = "neutral"
var center_node_area: Area2D

func _ready() -> void:
	_setup_center_node()

func _setup_center_node() -> void:
	center_node_area = Area2D.new()
	center_node_area.name = "CenterNodeArea"

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = CENTER_NODE_RADIUS
	shape.shape = circle

	center_node_area.add_child(shape)
	center_node_area.position = CENTER_NODE_POS
	add_child(center_node_area)

	center_node_area.body_entered.connect(_on_center_entered)

func _on_center_entered(body: Node) -> void:
	if not body.has_method("is_player_owned"):
		return

	var team := "player" if body.is_player_owned else "enemy"
	if team == center_controller:
		return

	center_controller = team
	center_captured.emit(team)

	if has_node("/root/QRRGField"):
		get_node("/root/QRRGField").apply_center_boost(team)

func get_lane_x(lane: Lane) -> float:
	match lane:
		Lane.VEIL:
			return VEIL_X
		Lane.CENTER_NODE:
			return CENTER_X
		Lane.FIELD:
			return FIELD_X
	return CENTER_X

func get_spawn_pos(lane: Lane, is_player: bool) -> Vector2:
	return Vector2(
		get_lane_x(lane),
		PLAYER_SPAWN_Y if is_player else ENEMY_SPAWN_Y
	)

func get_center_node_pos() -> Vector2:
	return CENTER_NODE_POS

func get_center_node_radius() -> float:
	return CENTER_NODE_RADIUS

func get_king_anchor_pos(is_player_target: bool) -> Vector2:
	return Vector2(
		CENTER_X,
		ENEMY_KING_Y if is_player_target else PLAYER_KING_Y
	)

func get_macro_route_points(lane: Lane, is_player: bool) -> Array[Vector2]:
	var route: Array[Vector2] = []
	route.append(get_spawn_pos(lane, is_player))
	route.append(CENTER_NODE_POS)
	route.append(get_king_anchor_pos(is_player))
	return route

func get_lane_from_screen_pos(screen_x: float) -> Lane:
	if screen_x < 270.0:
		return Lane.VEIL
	elif screen_x > 450.0:
		return Lane.FIELD
	return Lane.CENTER_NODE

func is_point_in_center_node(world_pos: Vector2) -> bool:
	return world_pos.distance_to(CENTER_NODE_POS) <= CENTER_NODE_RADIUS
