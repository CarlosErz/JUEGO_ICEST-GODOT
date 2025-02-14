extends CanvasLayer

@onready var vida_label = $Control/corazon
@onready var points_label = $Control/puntos
@onready var canva_red = $Control/rojo 
@onready var level_label = $Control/Label
 # Asegúrate de que sea un ColorRect

var parpadeo_activo = false
var tiempo = 0.0  # Para manejar el cambio de opacidad

func actualizar_vida(nueva_vida):
	if vida_label:
		vida_label.text = str(nueva_vida)

	if nueva_vida == 1:
		canva_red.visible = true
		parpadeo_activo = true  # Activar el parpadeo
	else:
		canva_red.visible = false
		parpadeo_activo = false
		canva_red.modulate.a = 1.0  # Restaurar la opacidad

func _process(delta):
	if parpadeo_activo:
		tiempo += delta
		canva_red.modulate.a = 0.5 + 0.5 * sin(tiempo * 5)  
func points(puntos):
	if points_label: 
		points_label.text = str(puntos)
		
func levels(level): 
	if level_label: 
		level_label.text = str(level)
func get_level(level):
	if level_label: 
		level_label.text = str("NIVEL:",level)
	
		
	
