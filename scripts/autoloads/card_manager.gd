extends Node

signal hand_updated(hand: Array[CardData])

const HAND_SIZE: int = 4
const LaneManagerScript = preload("res://scripts/arena/lane_manager.gd")

var deck: Array[CardData] = []
var hand: Array[CardData] = []
var discard: Array[CardData] = []

func load_deck(cards: Array[CardData]) -> void:
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

	var card: CardData = hand[index]

	if not ResonanceManager.can_spend(card.resonance_cost):
		return false

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

	var unit = card.unit_scene.instantiate()
	var scene := get_tree().current_scene
	if scene == null:
		push_warning("CardManager: no current scene available for unit spawn")
		return

	scene.add_child(unit)
	unit.global_position = _get_spawn_position(lane, pos)

	var route := _get_unit_route(lane, unit.global_position, true)
	if unit.has_method("initialize"):
		unit.initialize(card, true, lane, route)

func _get_spawn_position(lane: int, fallback_pos: Vector2) -> Vector2:
	var manager := _get_lane_manager()
	if manager != null and manager.has_method("get_spawn_pos"):
		return manager.get_spawn_pos(lane, true)

	# Fallback keeps the player spawn near the bottom while honoring the selected deploy zone.
	var x := fallback_pos.x
	if lane == LaneManagerScript.Lane.VEIL:
		x = LaneManagerScript.VEIL_X
	elif lane == LaneManagerScript.Lane.FIELD:
		x = LaneManagerScript.FIELD_X
	else:
		x = LaneManagerScript.CENTER_X
	return Vector2(x, LaneManagerScript.PLAYER_SPAWN_Y)

func _get_unit_route(lane: int, start_pos: Vector2, is_player: bool) -> Array[Vector2]:
	var manager := _get_lane_manager()
	if manager != null and manager.has_method("get_macro_route_points"):
		return manager.get_macro_route_points(lane, is_player, start_pos)

	# Fallback route: Veil/Field pressure bends through the Center Node control zone,
	# then redirects toward the enemy anchor direction. Center Node is not a normal lane.
	return [
		start_pos,
		LaneManagerScript.CENTER_NODE_POS,
		Vector2(LaneManagerScript.CENTER_X, LaneManagerScript.ENEMY_KING_Y)
	]

func _get_lane_manager() -> Node:
	var scene := get_tree().current_scene
	if scene == null:
		return null
	return scene.find_child("lanemanager", true, false)

func get_card_by_id(card_id: String) -> CardData:
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
