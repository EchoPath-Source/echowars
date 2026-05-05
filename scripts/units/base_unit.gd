extends CharacterBody2D

var is_player_owned: bool = true
var lane: int = 0
var card_data = null
var hp: float = 100.0
var damage: float = 10.0
var speed: float = 80.0
var route_points: Array[Vector2] = []
var route_index: int = 0

@onready var body: Polygon2D = $Body
@onready var name_label: Label = $NameLabel

func initialize(card, player_owned: bool, assigned_lane: int, route: Array[Vector2]) -> void:
	card_data = card
	is_player_owned = player_owned
	lane = assigned_lane

	if card_data != null:
		hp = card_data.hp
		damage = card_data.damage
		speed = card_data.speed
		name_label.text = card_data.card_name

	_set_team_visual()
	set_route(route)

func set_route(route: Array[Vector2]) -> void:
	route_points = route.duplicate()
	route_index = 0

	# Skip any first waypoint that is already effectively the spawn/deploy position.
	if route_points.size() > 0 and global_position.distance_to(route_points[0]) < 8.0:
		route_index = 1

func _physics_process(_delta: float) -> void:
	if route_index >= route_points.size():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var target := route_points[route_index]
	var to_target := target - global_position

	if to_target.length() <= 8.0:
		route_index += 1
		return

	velocity = to_target.normalized() * speed
	move_and_slide()

func _set_team_visual() -> void:
	if body == null:
		return

	if is_player_owned:
		body.color = Color(0.45, 0.75, 1.0, 1.0)
	else:
		body.color = Color(1.0, 0.35, 0.35, 1.0)
