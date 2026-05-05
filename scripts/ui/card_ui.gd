extends Control

signal drag_started

@onready var cost_label = $CostLabel
@onready var name_label = $CardNameLabel
@onready var faction_block = $FactionColorBlock

func _ready() -> void:
	# The root CardUI should receive the press event; visual children should not swallow it.
	mouse_filter = Control.MOUSE_FILTER_STOP
	$Background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CostLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$CardNameLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$FactionColorBlock.mouse_filter = Control.MOUSE_FILTER_IGNORE

func setup(card, index: int) -> void:
	cost_label.text = str(card.resonance_cost)
	name_label.text = _shorten_name(card.card_name)

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

func _shorten_name(card_name: String) -> String:
	if card_name.length() <= 14:
		return card_name
	return card_name.substr(0, 12) + "…"

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		drag_started.emit()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		drag_started.emit()
