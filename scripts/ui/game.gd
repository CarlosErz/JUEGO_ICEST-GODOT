extends Node2D

# Use @onready to defer node references until _ready() is called
@onready var reset_game = $GUI_RESET_GAME
@onready var jugador_start = $GUI

func _ready() -> void:
	# Find the player node and connect the signal
	var player = get_node("player")
	if player:
		# Use Callable to connect the signal
		player.connect("player_died", Callable(self, "_on_player_died"))

	# Hide the reset GUI at the start
	reset_game.visible = false
	jugador_start.visible = true

func _on_player_died():
	# Show the reset GUI and hide the player GUI when the player dies
	reset_game.visible = true
	jugador_start.visible = false

func _process(delta: float) -> void:
	pass
