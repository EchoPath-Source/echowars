extends Control

@export var card_ui_scene: PackedScene

var dragging_card: Control = null
var drag_origin_index: int = -1

func _ready() -> void:
	CardManager.hand_updated.connect(_on_hand_updated)

func _on_hand_updated(hand) -> void:
	var container = $HBoxContainer

	for child in container.get_children():
		child.queue_free()

	for i in range(hand.size()):
		if card_ui_scene == null:
			push_error("CardHand: card_ui_scene not assigned!")
			return

		var card_ui = card_ui_scene.instantiate()
		container.add_child(card_ui)
		card_ui.setup(hand[i], i)
		card_ui.drag_started.connect(_on_drag_started.bind(i, card_ui))

func _on_drag_started(index: int, card_ui: Control) -> void:
	drag_origin_index = index
	dragging_card = card_ui
	dragging_card.set_as_top_level(true)
	dragging_card.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and dragging_card:
		dragging_card.global_position = event.position - dragging_card.size * 0.5
	if event is InputEventMouseMotion and dragging_card:
		dragging_card.global_position = event.position - dragging_card.size * 0.5

	if event is InputEventScreenTouch and not event.pressed:
		if drag_origin_index >= 0:
			_try_deploy(event.position)
		_end_drag()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if drag_origin_index >= 0:
			_try_deploy(event.position)
		_end_drag()

func _try_deploy(screen_pos: Vector2) -> void:
	var lane := _get_lane_at_position(screen_pos)
	CardManager.play_card(drag_origin_index, lane, screen_pos)

func _end_drag() -> void:
	if dragging_card:
		dragging_card.set_as_top_level(false)
		dragging_card.mouse_filter = Control.MOUSE_FILTER_STOP
	dragging_card = null
	drag_origin_index = -1

func _get_lane_at_position(pos: Vector2) -> int:
	# Prototype touch regions:
	# left = Veil Lane
	# center = Center Node zone
	# right = Field Lane
	if pos.x < 270.0:
		return LaneManager.Lane.VEIL
	elif pos.x > 450.0:
		return LaneManager.Lane.FIELD
	return LaneManager.Lane.CENTER_NODE
