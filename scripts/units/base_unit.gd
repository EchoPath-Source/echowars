extends CharacterBody2D

var is_player_owned: bool = true
var lane: int = 0
var card_data = null
var hp: float = 100.0
var damage: float = 10.0
var speed: float = 80.0
var attack_range: float = 48.0
var attack_cooldown: float = 1.0
var attack_timer: float = 0.0
var route_points: Array[Vector2] = []
var route_index: int = 0
var current_target: Node2D = null

@onready var body: Polygon2D = $Body
@onready var name_label: Label = $NameLabel

func _ready() -> void:
	add_to_group("units")
	_set_team_visual()

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

func _physics_process(delta: float) -> void:
	attack_timer = maxf(attack_timer - delta, 0.0)
	_update_current_target()
	if current_target != null:
		velocity = Vector2.ZERO
		move_and_slide()
		_attack_current_target()
		return

	_follow_route()

func _follow_route() -> void:
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

func _update_current_target() -> void:
	if _has_valid_target(current_target):
		return

	current_target = _find_nearest_enemy_in_range()

func _has_valid_target(target: Node2D) -> bool:
	if target == null or not is_instance_valid(target):
		return false
	if target.get("is_player_owned") == is_player_owned:
		return false
	return global_position.distance_to(target.global_position) <= attack_range

func _find_nearest_enemy_in_range() -> Node2D:
	var nearest: Node2D = null
	var nearest_distance := attack_range

	for candidate in get_tree().get_nodes_in_group("units"):
		if candidate == self or not candidate is Node2D:
			continue
		if candidate.get("is_player_owned") == is_player_owned:
			continue

		var candidate_node := candidate as Node2D
		var distance := global_position.distance_to(candidate_node.global_position)
		if distance <= nearest_distance:
			nearest = candidate_node
			nearest_distance = distance

	return nearest

func _attack_current_target() -> void:
	if attack_timer > 0.0 or current_target == null:
		return
	if current_target.has_method("take_damage"):
		current_target.take_damage(damage)
	attack_timer = attack_cooldown

func take_damage(amount: float) -> void:
	hp -= amount
	if hp <= 0.0:
		queue_free()

func _set_team_visual() -> void:
	if body == null:
		return

	if is_player_owned:
		body.color = Color(0.45, 0.75, 1.0, 1.0)
	else:
		body.color = Color(1.0, 0.35, 0.35, 1.0)
