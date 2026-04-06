
class_name VeilAnchor
extends Area2D

signal anchor_destroyed(is_player_anchor: bool)

@export var is_player_anchor: bool = true
@export var is_king_anchor: bool = false
@export var max_resonance: float = 2400.0

var current_resonance: float = 2400.0
var is_active: bool = true

func take_damage(amount: float) -> void:
	if not is_active: return
	current_resonance = maxf(0.0, current_resonance - amount)
	_update_visual()
	if current_resonance <= 0.0:
		_on_destroyed()

func _on_destroyed() -> void:
	is_active = false
	GameState.add_crown(not is_player_anchor)
	anchor_destroyed.emit(is_player_anchor)
	# Unlock king anchor if this is a side anchor
	if not is_king_anchor:
		_reveal_king_anchor()
	# Visual: collapse animation stub
	queue_free()

func _update_visual() -> void:
	# Stub: update health bar, glow intensity
	var pct: float = current_resonance / max_resonance
	modulate.a = lerpf(0.5, 1.0, pct)

func _reveal_king_anchor() -> void:
	# Signal to arena to activate king anchor
	pass

func get_health_percent() -> float:
	return current_resonance / max_resonance
