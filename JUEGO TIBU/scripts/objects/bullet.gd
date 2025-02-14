extends RigidBody2D

@export var speed: float = -700.0  # Velocidad de la bala
@export var damage: int = 1  # Daño que causa la bala
@onready var bomba = $bomba  # Referencia al AnimatedSprite2D

func _ready():
	# Iniciar la animación de la bala
	if bomba:
		bomba.play("BOM_NORMAL")  # Asegúrate de que el nombre de la animación es correcto
	
	# Desactivamos la gravedad para evitar que la bomba caiga
	gravity_scale = 0  # Esto hace que la gravedad no afecte a la bomba

	# Mover la bomba en línea recta en el eje X
	linear_velocity = Vector2(speed, 0)  # Movimiento solo en X (horizontal), sin gravedad

	# Habilitar detección de colisiones
	contact_monitor = true
	max_contacts_reported = 5

	# Conectar la señal de colisión
	connect("body_entered", Callable(self, "_on_body_entered"))

# Cuando la bomba entra en contacto con un cuerpo
func _on_body_entered(body):

	if body.is_in_group("player"): # Verificar si el cuerpo pertenece al grupo 'player'
		body.take_damage(damage, global_position)  # Pasamos la posición de la bomba para el knockback
		queue_free()  # Destruir la bomba después de colisionar
	else:
		if body.is_in_group("pusheable") or body.is_in_group("FORMA NIVEL"):
			queue_free()
		  # Si choca con otra cosa, se destruye igual
