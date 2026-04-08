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

func _spawn_card(card, lane: int, pos: Vector2) -> void:
	if card.unit_scene == null:
		push_warning("Card %s has no unit_scene defined" % card.card_name)
		return

	var unit = card.unit_scene.instantiate()
	get_tree().current_scene.add_child(unit)
	unit.global_position = pos

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
