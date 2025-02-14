extends Node2D

@onready var player_initial_position_marker2D = $PuntoInicial # Asegúrate de que este nodo existe

func set_player_position(player: Node2D): 
	if player_initial_position_marker2D:
		player.global_position = player_initial_position_marker2D.global_position
	else:
		print("Error: No se encontró 'PuntoInicial' en el nivel.")
