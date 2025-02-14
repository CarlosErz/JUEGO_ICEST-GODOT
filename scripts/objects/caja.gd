extends RigidBody2D

# Fuerza de fricción para detener la caja gradualmente
@export var friction: float = 0.1

func _ready():
	# Configura el comportamiento inicial del RigidBody2D
	pass

func _integrate_forces(state):
	# Aplicar fricción para detener la caja gradualmente
	if linear_velocity.length() > 0:
		linear_velocity -= linear_velocity * friction * state.step
