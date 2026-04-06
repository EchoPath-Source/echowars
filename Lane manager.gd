class_name LaneManager
extends Node2D

enum Lane { VEIL, FIELD, CENTER_NODE }

@export var veil_lane_x: float = 200.0
@export var field_lane_x: float = 500.0
@export var center_node_x: float = 350.0
@export var arena_height: float = 1920.0

var center_node_contested: bool = false
var center_controller: String = 'neutral'  # 'player','enemy','neutral'

func get_lane_x(lane: Lane) -> float:
	match lane:
		Lane.VEIL:
			return veil_lane_x
		Lane.FIELD:
			return field_lane_x
		Lane.CENTER_NODE:
			return center_node_x
	return field_lane_x

func get_spawn_position(lane: Lane, is_player: bool) -> Vector2:
	var x: float = get_lane_x(lane)
	var y: float = arena_height * 0.85 if is_player else arena_height * 0.15
	return Vector2(x, y)

func get_target_position(lane: Lane, is_player: bool) -> Vector2:
	var x: float = get_lane_x(lane)
	var y: float = arena_height * 0.05 if is_player else arena_height * 0.95
	return Vector2(x, y)

func contest_center_node(team: String) -> void:
	center_node_contested = true
	center_controller = team
	# Apply field bonus based on controller - feeds into QRRGField
	if has_node("/root/QRRGField"): # Added a safety check for the Autoload
		get_node("/root/QRRGField").apply_center_boost(team)
