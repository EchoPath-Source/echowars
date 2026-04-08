class_name CardUI
extends Control

signal drag_started

@onready var cost_label = $CostLabel
@onready var name_label = $CardNameLabel
@onready var faction_block = $FactionColorBlock

func setup(card: CardData, _index: int) -> void:
	cost_label.text = str(card.resonance_cost)
	name_label.text = card.card_name

	match card.faction:
		"awakened_ones":
			faction_block.color = Color(0.5, 0.7, 0.85, 0.9)
		"loopbound":
			faction_block.color = Color(0.5, 0.4, 0.65, 0.9)
		"architects":
			faction_block.color = Color(0.8, 0.65, 0.3, 0.9)
		"forgotten_flame":
			faction_block.color = Color(0.8, 0.4, 0.2, 0.9)
		_:
			faction_block.color = Color(0.3, 0.3, 0.3, 0.9)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		drag_started.emit()
