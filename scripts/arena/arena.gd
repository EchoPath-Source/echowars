extends Node2D

const STARTER_DECK: Array[CardData] = [
	preload("res://data/cards/awakened_wandbearer.tres"),
	preload("res://data/cards/loopbound_echo_leech.tres"),
	preload("res://data/cards/architects_collapse_scribe.tres"),
	preload("res://data/cards/forgotten_flame_flamebearer.tres"),
]

func _ready() -> void:
	GameState.start_match()
	CardManager.load_deck(STARTER_DECK)
