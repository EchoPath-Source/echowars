extends CharacterBody2D
class_name BaseUnit

@export var arrival_radius: float = 12.0
@export var attack_range: float = 48.0
@export var attack_cooldown: float = 1.0

var is_player_owned: bool = true
var lane: int = 0
var card_data: CardData
var hp: float = 1.0
var damage: float = 0.0
var speed: float = 80.0
var route_points: Array[Vector2] = []
var route_index: int = 0
var attack_timer: float = 0.0
var current_target: BaseUnit = null

@onready var body_visual: Polygon2D = $BodyVisual
@onready var name_label: Label = $NameLabel

func initialize(card: CardData, player_owned: bool, deploy_lane: int, route: Array[Vector2]) -> void:
	card_data = card
	is_player_owned = player_owned
	lane = deploy_lane
	hp = card.hp
	damage = card.damage
	speed = card.speed
	route_points = route.duplicate()
	route_index = 0

	if route_points.size() > 0:
		global_position = route_points[0]
		if route_points.size() > 1:
			route_index = 1

	_apply_card_visuals()

func _ready() -> void:
	add_to_group("units")
	_apply_card_visuals()

func _physics_process(delta: float) -> void:
	attack_timer = maxf(0.0, attack_timer - delta)
	_refresh_target()

	if current_target != null:
		velocity = Vector2.ZERO
		_try_attack_current_target()
		return

	if route_index >= route_points.size():
		velocity = Vector2.ZERO
		return

	var target := route_points[route_index]
	var to_target := target - global_position

	if to_target.length() <= arrival_radius:
		route_index += 1
		velocity = Vector2.ZERO
		return

	velocity = to_target.normalized() * speed
	move_and_slide()

func take_damage(amount: float) -> void:
	hp -= amount
	if hp <= 0.0:
		queue_free()

func _refresh_target() -> void:
	if _is_valid_target(current_target) and global_position.distance_to(current_target.global_position) <= attack_range:
		return

	current_target = null
	var nearest_distance := attack_range

	for node in get_tree().get_nodes_in_group("units"):
		if node == self or not (node is BaseUnit):
			continue

		var unit := node as BaseUnit
		if unit.is_player_owned == is_player_owned:
			continue
		if unit.is_queued_for_deletion():
			continue

		var distance := global_position.distance_to(unit.global_position)
		if distance <= nearest_distance:
			nearest_distance = distance
			current_target = unit

func _try_attack_current_target() -> void:
	if attack_timer > 0.0 or not _is_valid_target(current_target):
		return

	current_target.take_damage(damage)
	attack_timer = attack_cooldown

func _is_valid_target(unit: BaseUnit) -> bool:
	return unit != null \
		and is_instance_valid(unit) \
		and not unit.is_queued_for_deletion() \
		and unit.is_player_owned != is_player_owned

func _apply_card_visuals() -> void:
	if body_visual == null or name_label == null or card_data == null:
		return

	name_label.text = card_data.card_name

	match card_data.faction:
		"awakened_ones":
			body_visual.color = Color(0.35, 0.85, 1.0)
		"loopbound":
			body_visual.color = Color(0.75, 0.35, 1.0)
		"architects":
			body_visual.color = Color(1.0, 0.85, 0.25)
		"forgotten_flame":
			body_visual.color = Color(1.0, 0.3, 0.1)
		_:
			body_visual.color = Color(0.9, 0.9, 0.9)
