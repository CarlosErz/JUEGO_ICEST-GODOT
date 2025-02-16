extends Node2D

# Ruta a la carpeta de niveles
var niveles_folder = "res://SCENES/levels/"
@onready var transition_scene = preload("res://SCENES/ui/transition.tscn") 
@onready var ui = get_tree().current_scene.get_node("GUI") # Escena de transición

# Lista de nombres de archivos de niveles
var niveles = ["Level0.tscn","Level1.tscn", "Level2.tscn"]  # Agrega más niveles aquí

# Índice del nivel actual
var nivel_actual = 2

# Referencia al jugador
var jugador

func _ready():
	# Obtener la referencia al jugador usando una ruta relativa
	jugador = $"../player"  # Busca el nodo "player" en el nodo padre
	if not jugador or not (jugador is Node2D):
		print("Error: No se encontró el nodo 'player' o no es un CharacterBody2D.")
		return

	# Iniciar el primer nivel
	cambiar_nivel(nivel_actual)

# Cambiar al nivel especificado por índice
func cambiar_nivel(indice):
	if indice < 0 or indice >= niveles.size():
		print("Error: Índice de nivel fuera de rango.")
		return

	# Mostrar la transición antes de cargar el nuevo nivel
	var transition_instance = transition_scene.instantiate()
	add_child(transition_instance)  # Añadir la transición a la escena actual

	# Cargar la escena del nivel
	var nivel_path = niveles_folder + niveles[indice]
	var nivel_escena = load(nivel_path)

	if nivel_escena:
		print("Cargando nivel:", nivel_path)

		# Eliminar el nivel anterior si existe, sin borrar al jugador
		var nodos_a_eliminar = []
		for child in get_children():
			if child != jugador:  # No eliminar al jugador
				nodos_a_eliminar.append(child)

		for nodo in nodos_a_eliminar:
			if is_instance_valid(nodo):  # Asegurar que el nodo no fue eliminado antes
				nodo.queue_free()

		# Instanciar y agregar el nuevo nivel
		await get_tree().process_frame  # Esperar un frame para evitar errores
		var nivel_instancia = nivel_escena.instantiate()
		add_child(nivel_instancia)
		nivel_actual = indice
		if ui: 
			ui.get_level(nivel_actual)

		# Mover el jugador al punto inicial del nivel
		if nivel_instancia.has_method("set_player_position"):
			nivel_instancia.set_player_position(jugador)
		else:
			print("Error: El nivel no tiene la función 'set_player_position'.")

		# Eliminar la transición después de cargar el nivel
		await get_tree().create_timer(0.5).timeout
		if is_instance_valid(transition_instance):
			transition_instance.queue_free()
	else:
		print("Error: No se pudo cargar la escena del nivel.")

# Ir al siguiente nivel
func siguiente_nivel():
	if nivel_actual + 1 < niveles.size():
		cambiar_nivel(nivel_actual+1)
	else:
		print("¡Has completado todos los niveles!")

# Reiniciar el nivel actual
func reiniciar_nivel():
	cambiar_nivel(nivel_actual)
