extends Node2D

@onready var shoot_point = $ShootPoint  # Referencia al punto de disparo
@onready var animation_canno = $AnimatedSprite2D  # Sprite animado del cañón
@onready var timer = $ShootTimer # Referencia al temporizador (debe estar en la escena)
@export var bullet_scene: PackedScene  # Escena de la bala
@export var fire_rate: float = 1.5  # Intervalo de disparo en segundos

func _ready():
	timer.wait_time = fire_rate  # Configurar el tiempo entre disparos
	timer.autostart = true  # Iniciar automáticamente
	timer.start()  # Iniciar el temporizador
	timer.connect("timeout", Callable(self, "shoot"))  # Conectar el temporizador con la función shoot

func shoot():
	if bullet_scene:  # Verificar si la bala está asignada
		animation_canno.play("RELOAD")  # Animación de recarga
		await get_tree().create_timer(0.5).timeout  # Esperar recarga

		animation_canno.play("SHOOT")  # Animación de disparo
		await get_tree().create_timer(0.2).timeout  # Esperar la animación

		animation_canno.stop()  # Detener animación después del disparo

		# Instanciar y disparar la bala
		var bullet = bullet_scene.instantiate()
		if bullet:
			# Verificar si hay una escena actual
			if get_tree().current_scene:
				get_tree().current_scene.add_child(bullet)
				bullet.global_position = shoot_point.global_position  # Posicionar la bala
				bullet.rotation_degrees = 90  # Ajustar la rotación si es necesario
				bullet.scale = Vector2(2, 2)  # Escalar la bala si es necesario
			else:
				print("❌ ERROR: No hay una escena actual cargada.")
		else:
			print("❌ ERROR: No se pudo instanciar la bala.")  # Mensaje de error
	else:
		print("❌ ERROR: No se ha asignado la escena de la bala.")  # Verificación
