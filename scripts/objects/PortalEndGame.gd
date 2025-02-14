# PortalEndGame.gd
extends Area2D

# Referencia al nodo AnimationPlayer
@onready var animation_player = $AnimatedSprite2D

# Conectar la señal 'body_entered' en el _ready() si no lo has hecho en el editor.
func _ready():
	# Conectar la señal 'body_entered' a la función '_on_body_entered' del script.
	connect("body_entered", Callable(self, "_on_body_entered"))
	# Reproducir la animación 'PORTAL' de forma continua.
	animation_player.play("PORTAL")

# Función llamada cuando el jugador entra en el área
func _on_body_entered(body) -> void:
	print(body)
	if body.name == "player":  # Verificar que el jugador tenga el nombre correcto
		print("¡Nivel completado!")
		
		# Acceder al nodo LevelManager en la escena actual
		var level_manager = get_tree().current_scene.get_node("LevelManager")
		
		if level_manager:
			level_manager.siguiente_nivel()  # Cambiar al siguiente nivel
		else:
			print("Error: No se encontró el nodo 'LevelManager' en la escena actual.")
