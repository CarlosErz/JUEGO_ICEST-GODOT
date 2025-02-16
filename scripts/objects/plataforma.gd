extends CharacterBody2D

@onready var animation_base = $AnimatedSprite2D

@export var move_distance: float = 100  
@export var move_speed: float = 100  

var direction: int
var start_position: Vector2
var time_offset: float  # Pequeño desfase temporal único para cada instancia

func _ready():
	start_position = position  
	direction = [-1, 1].pick_random()  # Dirección aleatoria al inicio
	time_offset = randf() * 2  # Desfase entre 0 y 2 segundos
	animation_base.play("flotando")

	
func _physics_process(_delta):
	var time = Time.get_ticks_msec() / 1000.0  # Tiempo en segundos
	position.x = start_position.x + sin(time + time_offset) * move_distance
