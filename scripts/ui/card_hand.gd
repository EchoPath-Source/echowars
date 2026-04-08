class_name CardHand
extends Control

@export var card_ui_scene: PackedScene

var dragging_card = null
var drag_origin_index: int = -1

func _ready() -> void:
	CardManager.hand_updated.connect(_on_hand_updated)

func _on_hand_updated(hand) -> void:
	var container = $HBoxContainer

	for child in container.get_children():
		child.queue_free()

	for i in range(hand.size()):
		if card_ui_scene == null:
			push_error("CardHand: card_ui_scene not assigned")
			return

		var card_ui = card_ui_scene.instantiate()
		container.add_child(card_ui)
		card_ui.setup(hand[i], i)
		card_ui.drag_started.connect(_on_drag_started.bind(i))

func _on_drag_started(index: int) -> void:
	drag_origin_index = index

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and dragging_card:
		dragging_card.global_position = event.position

	if event is InputEventScreenTouch and not event.pressed:
		if drag_origin_index >= 0:
			_try_deploy(event.position)
		dragging_card = null
		drag_origin_index = -1

func _try_deploy(screen_pos: Vector2) -> void:
	var lane = _get_lane_at_position(screen_pos)
	CardManager.play_card(drag_origin_index, lane, screen_pos)

func _get_lane_at_position(pos: Vector2) -> int:
	if pos.x < 280.0:
		return LaneManager.Lane.VEIL
	elif pos.x > 420.0:
		return LaneManager.Lane.FIELD
	return LaneManager.Lane.CENTER_NODE
