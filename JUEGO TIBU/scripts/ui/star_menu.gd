extends Node2D

@onready var button_start = $CanvasLayer/VBoxContainer/Button  # Referencia al botón
@onready var transition_scene = preload("res://SCENES/ui/transition.tscn")  # Cargar la escena de transición

func _ready() -> void:
	button_start.connect("pressed", Callable(self, "_on_button_start_pressed")) 
	$Camera2D.make_current() # Conectar señal

func _on_button_start_pressed() -> void:
	var transition_instance = transition_scene.instantiate()
	add_child(transition_instance)  # Añadirla a la escena actual
	transition_instance.transition_to("res://SCENES/world/game.tscn")  # Llamar a la función de transición
