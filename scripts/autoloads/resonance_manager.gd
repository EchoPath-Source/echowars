extends Node

signal resonance_changed(new_value: float, max_value: float)

@export var max_resonance: float = 10.0
@export var regen_rate: float = 1.0

var current_resonance: float = 5.0
var double_regen_active: bool = false

func _process(delta: float) -> void:
	if GameState.current_phase != GameState.Phase.ACTIVE \
	and GameState.current_phase != GameState.Phase.OVERTIME:
		return

	var rate: float = regen_rate * (2.0 if double_regen_active else 1.0)
	current_resonance = minf(max_resonance, current_resonance + rate * delta)
	resonance_changed.emit(current_resonance, max_resonance)

func can_spend(amount: float) -> bool:
	return current_resonance >= amount

func spend(amount: float) -> bool:
	if not can_spend(amount):
		return false

	current_resonance -= amount
	resonance_changed.emit(current_resonance, max_resonance)
	return true

func enable_double_regen() -> void:
	double_regen_active = true
