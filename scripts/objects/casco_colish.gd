extends Area2D

@export var points: int = 10
 # Puntos que da el objeto

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.add_points(points)  
		
		# Sumar puntos
		queue_free()  # Destruir el objeto
	else:
		print("⚠️ ERROR: ¡El nodo no está en el grupo 'player'!")  # Depuración
