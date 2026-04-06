class_name MatchHUD
extends CanvasLayer

@onready var timer_label = $VBoxContainer/TimerLabel
@onready var player_crowns = $VBoxContainer/HBoxContainer/PlayerCrowns
@onready var enemy_crowns = $VBoxContainer/HBoxContainer/EnemyCrowns
@onready var win_screen = $WinScreen
@onready var win_label = $WinScreen/WinLabel

func _ready() -> void:
		GameState.phase_changed.connect(_on_phase_changed)
		GameState.match_ended.connect(_on_match_ended)
		win_screen.visible = false  # hidden at start
	
func _process(_delta: float) -> void:
					if GameState.current_phase == GameState.Phase.ACTIVE \
						or GameState.current_phase == GameState.Phase.OVERTIME:
						var t := GameState.time_remaining
						var mins := int(t) / 60
						var secs := int(t) % 60
						timer_label.text = "%d:%02d" % [mins, secs]
						player_crowns.text = "Player: %d" % GameState.player_crowns
						enemy_crowns.txt = "Enemy: %d" % GameState.enemy_crowns
																			
func _on_phase_changed(phase: String) -> void:
	if phase == "OVERTIME":
		timer_label.modulate = Color.RED
																					
func _on_match_ended(winner: String) -> void:
	timer_label.text = winner.to_upper() + " WINS"
	win_label.text = winner.to_upper() + " WINS!"
