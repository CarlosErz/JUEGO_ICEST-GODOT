extends StaticBody2D

# Colisión unidireccional
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# Asegúrate de que el CollisionShape2D está configurado correctamente
	if collision_shape:
		if collision_shape.shape is RectangleShape2D or collision_shape.shape is ConvexPolygonShape2D:
			collision_shape.one_way_collision = true # Margen opcional para facilitar el paso hacia abajo
