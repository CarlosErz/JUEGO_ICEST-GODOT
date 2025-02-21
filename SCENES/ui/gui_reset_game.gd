extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var restart_button = $RestartButton  # Asegúrate de que este nodo exista en tu escena

func update_score(score):
	score_label.text =  str(score)

func _ready():
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	
func _on_restart_button_pressed():
	# Reanudar el juego si estaba pausado
	get_tree().paused = false
	# Recargar la escena actual
	get_tree().reload_current_scene()
