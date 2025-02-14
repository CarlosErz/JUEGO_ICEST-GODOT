class_name Box
extends CharacterBody2D

# Variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 0
var is_being_carried: bool = false

func _physics_process(delta: float) -> void:
	if is_being_carried:
		return  # No aplicar gravedad ni mover la caja si está siendo cargada

	# Aplicar gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Mover la caja en la dirección horizontal si hay una fuerza aplicada
	velocity.x = direction * 100

	# Mover la caja y manejar colisiones
	move_and_slide()

	# Asegurarse de que la caja se mueva con las plataformas móviles
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("moving_platform"):
			velocity += collision.get_collider().velocity

func set_being_carried(value: bool):
	is_being_carried = value
	if value:
		velocity = Vector2.ZERO  # Detener cualquier movimiento cuando se carga
