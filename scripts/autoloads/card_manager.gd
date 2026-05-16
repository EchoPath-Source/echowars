extends Node

signal hand_updated(hand)

const HAND_SIZE: int = 4

var deck = []
var hand = []
var discard = []

func load_deck(cards) -> void:
	deck = cards.duplicate()
	deck.shuffle()
	hand.clear()
	discard.clear()
	_fill_hand()

func _fill_hand() -> void:
	while hand.size() < HAND_SIZE and deck.size() > 0:
		hand.append(deck.pop_front())

	if deck.size() == 0 and discard.size() > 0:
		deck = discard.duplicate()
		deck.shuffle()
		discard.clear()

		while hand.size() < HAND_SIZE and deck.size() > 0:
			hand.append(deck.pop_front())

	hand_updated.emit(hand)

func play_card(index: int, lane: int, position: Vector2) -> bool:
	if index < 0 or index >= hand.size():
		return false

	var card = hand[index]

	if not ResonanceManager.spend(card.resonance_cost):
		return false

	_spawn_card(card, lane, position)

	hand.remove_at(index)
	discard.append(card)
	_fill_hand()
	return true

func _spawn_card(card: CardData, lane: int, pos: Vector2) -> void:
	if card.unit_scene == null:
		push_warning("Card %s has no unit_scene defined" % card.card_name)
		return

	var current_scene := get_tree().current_scene
	if current_scene == null:
		push_warning("CardManager could not spawn %s because there is no current scene" % card.card_name)
		return

	var unit = card.unit_scene.instantiate()
	current_scene.add_child(unit)

	var route := _build_spawn_route(lane, pos)
	var spawn_pos := pos
	if route.size() > 0:
		spawn_pos = route[0]

	if unit.has_method("initialize"):
		unit.initialize(card, true, lane, route)
	else:
		unit.global_position = spawn_pos

func _build_spawn_route(lane: int, fallback_screen_pos: Vector2) -> Array[Vector2]:
	var lane_manager := _find_lane_manager()
	if lane_manager != null and lane_manager.has_method("get_macro_route_points"):
		# Player units converge through the Center Node zone before pressing the opposing anchor.
		return lane_manager.get_macro_route_points(lane, true)

	var fallback_world_pos := _screen_to_world_position(fallback_screen_pos)
	return [
		fallback_world_pos,
		Vector2(360.0, 960.0),
		Vector2(360.0, 120.0),
	]

func _find_lane_manager() -> Node:
	var current_scene := get_tree().current_scene
	if current_scene == null:
		return null

	return current_scene.find_child("lanemanager", true, false)

func _screen_to_world_position(screen_pos: Vector2) -> Vector2:
	var current_scene := get_tree().current_scene
	if current_scene == null:
		return screen_pos

	var viewport := current_scene.get_viewport()
	var camera := viewport.get_camera_2d()
	if camera == null:
		return screen_pos

	return camera.get_screen_center_position() + (screen_pos - viewport.get_visible_rect().size * 0.5) / camera.zoom

func get_card_by_id(card_id: String):
	for card in deck:
		if card.card_id == card_id:
			return card
	for card in hand:
		if card.card_id == card_id:
			return card
	for card in discard:
		if card.card_id == card_id:
			return card
	return null
