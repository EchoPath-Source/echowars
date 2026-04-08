class_name CardData
extends Resource

@export var card_id: String = ""
@export var card_name: String = ""
@export var faction: String = ""
@export var card_type: String = ""
@export var description: String = ""
@export var resonance_cost: int = 3
@export var hp: float = 300.0
@export var damage: float = 100.0
@export var speed: float = 80.0
@export var unit_scene: PackedScene
@export var thumbnail: Texture2D
@export var jitter: float = 0.1
@export var path_directness: float = 0.8
@export var hesitation_rate: float = 0.1
@export var momentum_decay: float = 0.2
