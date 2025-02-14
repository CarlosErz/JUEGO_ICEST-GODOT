extends Area2D

@export var damage: int = 1  # Daño que causan los pinchos
@export var damage_interval: float = 0.2  # Intervalo de tiempo entre cada daño
@export var min_show_time: float = 1.0  # Tiempo mínimo que los pinchos estarán visibles
@export var max_show_time: float = 5.0  # Tiempo máximo que los pinchos estarán visibles
@export var min_hide_time: float = 2.0  # Tiempo mínimo que los pinchos estarán ocultos
@export var max_hide_time: float = 3.0  # Tiempo máximo que los pinchos estarán ocultos

@onready var animation_pinchos = $animacion_pinchos

var bodies_in_contact = []  # Lista para almacenar los cuerpos en contacto
var damage_timer: Timer = null

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
	# Iniciar el ciclo de mostrar/ocultar pinchos
	start_pinchos_cycle()

func start_pinchos_cycle():
	# Mostrar los pinchos y luego ocultarlos después de un tiempo aleatorio
	show_pinchos()
	var show_time = randf_range(min_show_time, max_show_time)
	await get_tree().create_timer(show_time).timeout
	hide_pinchos()
	
	# Ocultar los pinchos y luego mostrarlos después de un tiempo aleatorio
	var hide_time = randf_range(min_hide_time, max_hide_time)
	await get_tree().create_timer(hide_time).timeout
	
	# Repetir el ciclo
	start_pinchos_cycle()

func show_pinchos():
	animation_pinchos.play("SHOW_PINCHOS")
	# Activar el CollisionShape2D cuando los pinchos están visibles
	$CollisionShape2D.set_deferred("disabled", false)

func hide_pinchos():
	animation_pinchos.stop()
	animation_pinchos.frame = 0  # Ocultar los pinchos (frame 0)
	# Desactivar el CollisionShape2D cuando los pinchos están ocultos
	$CollisionShape2D.set_deferred("disabled", true)

func _on_body_entered(body):
	if body.is_in_group("player"):
		bodies_in_contact.append(body)
		apply_damage(body)  # Aplicar daño inmediatamente al entrar en contacto
		start_damage_timer(body)  # Iniciar el temporizador para aplicar daño continuo

func _on_body_exited(body):
	if body in bodies_in_contact:
		bodies_in_contact.erase(body)
		stop_damage_timer()  # Detener el temporizador cuando el jugador deja de estar en contacto

func apply_damage(body):
	if body.has_method("take_damage"):
		body.take_damage(damage, global_position)  # Aplicar daño al jugador

func start_damage_timer(body):
	damage_timer = Timer.new()
	damage_timer.wait_time = damage_interval
	damage_timer.autostart = true
	damage_timer.connect("timeout", Callable(self, "_on_damage_timer_timeout").bind(body))
	add_child(damage_timer)

func stop_damage_timer():
	if damage_timer:
		damage_timer.stop()
		damage_timer.queue_free()
		damage_timer = null

func _on_damage_timer_timeout(body):
	if body in bodies_in_contact:
		apply_damage(body)  # Aplicar daño continuo mientras el jugador esté en contacto
