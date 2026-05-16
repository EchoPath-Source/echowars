extends CanvasLayer

@onready var timer_label = $HUDRoot/VBoxContainer/TimerLabel
@onready var player_crowns = $HUDRoot/VBoxContainer/HBoxContainer/PlayerCrowns
@onready var enemy_crowns = $HUDRoot/VBoxContainer/HBoxContainer/EnemyCrowns
@onready var win_screen = $HUDRoot/WinScreen
@onready var win_label = $HUDRoot/WinScreen/WinLabel

var resonance_bar: Control = null

func _ready() -> void:
	GameState.phase_changed.connect(_on_phase_changed)
	GameState.match_ended.connect(_on_match_ended)

	win_screen.visible = false

	if has_node("HUDRoot/ResonanceBar"):
		resonance_bar = $HUDRoot/ResonanceBar
		ResonanceManager.resonance_changed.connect(_on_resonance_changed)
		_on_resonance_changed(ResonanceManager.current_resonance, ResonanceManager.max_resonance)

func _process(_delta: float) -> void:
	if GameState.current_phase != GameState.Phase.ACTIVE \
	and GameState.current_phase != GameState.Phase.OVERTIME:
		return

	var t := GameState.time_remaining
	var mins := int(t) / 60
	var secs := int(t) % 60
	timer_label.text = "%d:%02d" % [mins, secs]

	player_crowns.text = "Player: %d" % GameState.player_crowns
	enemy_crowns.text = "Enemy: %d" % GameState.enemy_crowns

func _on_phase_changed(phase: String) -> void:
	if phase == "OVERTIME":
		timer_label.modulate = Color.RED
	elif phase == "ACTIVE":
		timer_label.modulate = Color.WHITE

func _on_match_ended(winner: String) -> void:
	timer_label.text = winner.to_upper() + " WINS"
	win_label.text = winner.to_upper() + " WINS!"
	win_screen.visible = true

func _on_resonance_changed(current: float, max_val: float) -> void:
	if resonance_bar == null:
		return

	if resonance_bar.has_method("set_value"):
		resonance_bar.set_value(int((current / max_val) * 100))

	if resonance_bar.has_node("Label"):
		resonance_bar.get_node("Label").text = "%.1f / %.1f" % [current, max_val]
