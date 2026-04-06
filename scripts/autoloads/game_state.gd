# scripts/autoloads/game_state.gd
extends Node

signal match_started
signal match_ended(winner: String)
signal phase_changed(new_phase: String)

enum Phase { WAITING, ACTIVE, OVERTIME, GOAL_PAUSE, ENDED }

# Checklist: Update durations for 2026 build
@export var match_duration: float = 90.0  # Changed from 180 to 90
@export var overtime_duration: float = 30.0 # Standard 30s overtime

var current_phase: Phase = Phase.WAITING
var time_remaining: float = 0.0
var player_crowns: int = 0
var enemy_crowns: int = 0

func start_match() -> void:
	current_phase = Phase.ACTIVE
	time_remaining = match_duration
	match_started.emit()
	phase_changed.emit("ACTIVE")

func _process(delta: float) -> void:
	# Stop the clock if waiting, paused for a goal, or ended
	if current_phase == Phase.WAITING or current_phase == Phase.GOAL_PAUSE or current_phase == Phase.ENDED:
		return
		
	time_remaining -= delta
	
	if time_remaining <= 0.0:
		_handle_time_expired()

func pause_for_goal() -> void:
	current_phase = Phase.GOAL_PAUSE
	phase_changed.emit("GOAL_PAUSE")
	# Logic to reset units would be triggered here

func resume_after_goal() -> void:
	current_phase = Phase.ACTIVE
	phase_changed.emit("ACTIVE")

func _handle_time_expired() -> void:
	if current_phase == Phase.ACTIVE:
		if player_crowns != enemy_crowns:
			_determine_winner()
		else:
			# Enter Overtime Phase
			current_phase = Phase.OVERTIME
			time_remaining = overtime_duration
			# Check if ResonanceManager exists before calling
			if has_node("/root/ResonanceManager"):
				get_node("/root/ResonanceManager").enable_double_regen()
			phase_changed.emit("OVERTIME")
	else:
		_determine_winner()

func _determine_winner() -> void:
	current_phase = Phase.ENDED
	var winner = "player" if player_crowns > enemy_crowns else "enemy"
	if player_crowns == enemy_crowns: winner = "draw"
	match_ended.emit(winner)

func add_crown(is_player: bool) -> void:
	if is_player: player_crowns += 1
	else: enemy_crowns += 1
	
	# Automatically pause the match timer when a crown is taken
	pause_for_goal()
