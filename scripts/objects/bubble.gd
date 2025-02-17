extends Area2D

# Se conecta el nodo a las señales necesarias al entrar en escena
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_BubblePickup_body_entered"))

# Función que se ejecuta al entrar un cuerpo al área
func _on_BubblePickup_body_entered(body): 
	if body.is_in_group("player"):  # Verifica si el cuerpo pertenece al grupo "player"
		body.has_bubble_power = true 
		if body.has_method("add_bubble"):  # Verifica si el cuerpo tiene el método "add_bubble"
			body.add_bubble() 
		queue_free()  # Elimina el nodo de la burbuja tras ser recogido
