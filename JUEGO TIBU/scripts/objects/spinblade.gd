extends Area2D

@export var damage: int = 2  # Daño que causará el SpinBlade
@export var damage_interval: float = 0.1  # Intervalo de tiempo entre cada daño

# Referencia al sprite del SpinBlade (opcional para animaciones)
@onready var spinblade_sprite = $Sprite2D

# Almacena las entidades en contacto
var bodies_in_contact = []
var damage_timer: Timer = null

func _ready() -> void:
	# Conectar señales del área
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

# Detecta cuando un cuerpo entra en contacto
func _on_body_entered(body):
	if body.is_in_group("player"):  # Asegúrate de que el jugador esté en un grupo llamado "player"
		bodies_in_contact.append(body)  # Añadir a la lista de contacto
		apply_damage(body)  # Aplicar daño inmediatamente al entrar en contacto
		start_damage_timer()  # Iniciar el temporizador para aplicar daño continuo

# Detecta cuando un cuerpo sale del área
func _on_body_exited(body):
	if body in bodies_in_contact:
		bodies_in_contact.erase(body)  # Elimina de la lista de contacto
		if bodies_in_contact.is_empty():
			stop_damage_timer()  # Detener el temporizador si no hay cuerpos en contacto

# Aplicar daño a un cuerpo específico
func apply_damage(body):
	if body.has_method("take_damage"):  # Verifica que el cuerpo tenga un método `take_damage`
		body.take_damage(damage, global_position)  # Aplica el daño

# Iniciar el temporizador para aplicar daño continuo
func start_damage_timer():
	if damage_timer == null:
		damage_timer = Timer.new()
		damage_timer.wait_time = damage_interval
		damage_timer.autostart = true
		damage_timer.connect("timeout", Callable(self, "_on_damage_timer_timeout"))
		add_child(damage_timer)

# Detener el temporizador
func stop_damage_timer():
	if damage_timer:
		damage_timer.stop()
		damage_timer.queue_free()
		damage_timer = null

# Aplicar daño a todos los cuerpos en contacto cuando el temporizador finaliza
func _on_damage_timer_timeout():
	for body in bodies_in_contact:
		apply_damage(body)

# Lógica adicional (opcional)
# Aquí puedes añadir rotaciones o animaciones para el SpinBlade si es necesario.
func _process(delta: float) -> void:
	spinblade_sprite.play("spinblade")  # Ejemplo de animación
