class_name TibuPlayer
extends CharacterBody2D

signal player_died
@onready var animated_sprite = $animacion_tibu
@onready var detecta_caja: RayCast2D = $Detecta_caja
@onready var ui = get_tree().current_scene.get_node("GUI")
@onready var ui_reset = get_tree().current_scene.get_node("GUI_RESET_GAME")
@onready var bubble_effect = $BubbleEffect
@onready var label_dont_have_bubble = $noSuperBurbuja

# Constants for magic numbers
const GRAVITY_MULTIPLIER := 1.5
const INVINCIBILITY_DURATION := 0.2
const BUBBLE_SHOW_TIME := 2.0

@export var move_speed: float = 200
@export var jump_speed: float = 400
@export var dash_speed_multiplier: float = 2.0
@export var dash_duration: float = 0.5
@export var push_force: float = 200
@export var gravity_scale: float = 1.0
@export var fall_gravity_multiplier: float = GRAVITY_MULTIPLIER
@export var coyote_time_duration: float = 0.1
@export var jump_buffer_time: float = 0.1
@export var bubble_duration: float = 5.0
@export var bubble_cooldown: float = 10.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale
var is_facing_right = true
var health: int = 3
var is_invincible: bool = false
var score: int = 0
var is_dashing: bool = false
var dash_timer: float = 0.0
var max_jumps: int = 2
var jump_count: int = 0
var coyote_time_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var is_alive: bool = true

var has_bubble_power: bool = false
var has_bubble: bool = false
var cooldown_timer: float = 0.0
var bubble_count: int = 0

func _physics_process(delta):
	if is_alive:
		handle_movement(delta)
		handle_jump(delta)
		handle_flip()
		update_animations()
		move_and_slide()
		handle_drop_down()

		handle_bubble(delta)

		if detecta_caja.is_colliding():
			var caja = detecta_caja.get_collider()
			push_caja(caja)

		if is_dashing:
			dash_timer -= delta
			if dash_timer <= 0:
				is_dashing = false
	else:
		velocity = Vector2.ZERO

func handle_movement(delta):
	if not is_alive:
		return

	var direction = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("move_run") and direction and not is_dashing:
		start_dash()

	if is_dashing:
		velocity.x = direction * move_speed * dash_speed_multiplier
	else:
		velocity.x = direction * move_speed

	if not is_on_floor():
		velocity.y += gravity * (fall_gravity_multiplier if velocity.y > 0 else 1.0) * delta

	if is_on_floor():
		coyote_time_timer = coyote_time_duration
	else:
		coyote_time_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

func start_dash():
	is_dashing = true
	dash_timer = dash_duration

func handle_jump(delta):
	if not is_alive:
		return

	if jump_buffer_timer > 0 and (is_on_floor() or coyote_time_timer > 0):
		velocity.y = -jump_speed
		jump_count = 1
		jump_buffer_timer = 0.0
		coyote_time_timer = 0.0

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_time_timer > 0:
			velocity.y = -jump_speed
			jump_count = 1
			coyote_time_timer = 0.0
		elif jump_count < max_jumps:
			velocity.y = -jump_speed
			jump_count += 1

func handle_flip():
	if not is_alive:
		return

	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

func update_animations():
	if not is_alive:
		animated_sprite.play("MUERTE")
		return

	if detecta_caja.is_colliding():
		var caja = detecta_caja.get_collider()
		if caja.is_in_group("pusheable") and velocity.x != 0:
			animated_sprite.play("PUSH")
			return
	
	if is_dashing:
		animated_sprite.play("TIBUSPEED")
	elif not is_on_floor():
		animated_sprite.play("DOOBLEJUMP" if jump_count == 2 else "JUMP")
	elif velocity.x != 0:
		animated_sprite.play("RUN")
	else:
		animated_sprite.play("IDEL")

	if not is_dashing and animated_sprite.animation == "TIBUSPEED":
		animated_sprite.stop()
		update_animations()

func push_caja(caja):
	if not is_alive:
		return

	if caja.is_in_group("pusheable"):
		var direction = Vector2(-1 if not is_facing_right else 1, 0)
		caja.velocity = direction * push_force
		caja.move_and_slide()

func activate_bubble():
	if not has_bubble_power or cooldown_timer > 0 or has_bubble:
		return

	has_bubble = true
	is_invincible = true
	animated_sprite.modulate = Color(0.5, 0.5, 1)

	if bubble_effect:
		bubble_effect.show()
	bubble_count -= 1
	if ui:
		ui.update_bubble_count(bubble_count)

func handle_bubble(delta):
	if cooldown_timer > 0:
		cooldown_timer -= delta

func deactivate_bubble():
	has_bubble = false
	is_invincible = false
	cooldown_timer = bubble_cooldown
	animated_sprite.modulate = Color(1, 1, 1)

	if bubble_effect:
		bubble_effect.hide()

func _input(event):
	if event.is_action_pressed("activate_bubble"):
		if bubble_count <= 0:
			label_dont_have_bubble.show()
			await get_tree().create_timer(BUBBLE_SHOW_TIME).timeout
			label_dont_have_bubble.hide()
			return
		activate_bubble()

func handle_drop_down():
	if Input.is_action_pressed("drop_down") and is_on_floor():
		global_position.y += 1.5

func show_no_bubble_message():
	label_dont_have_bubble.show()
	await get_tree().create_timer(BUBBLE_SHOW_TIME).timeout
	label_dont_have_bubble.hide()

func take_damage(amount, source_position):
	if not is_alive:
		return
	
	if has_bubble:
		deactivate_bubble()
		velocity = (global_position - source_position).normalized() * 700
		return

	health -= amount
	if ui:
		ui.actualizar_vida(health)
	else:
		print("Error: No se encontró GUI")
	velocity = (global_position - source_position).normalized() * 400
	is_invincible = true
	animated_sprite.modulate = Color(1, 0, 0)
	await invincibility_timer()
	if health <= 0:
		die()

func die():
	is_alive = false
	animated_sprite.play("MUERTE")
	set_physics_process(false)
	emit_signal("player_died")
	restart_game()

func invincibility_timer():
	await get_tree().create_timer(INVINCIBILITY_DURATION).timeout
	animated_sprite.modulate = Color(1, 1, 1)
	await get_tree().create_timer(0.1).timeout
	is_invincible = false

func add_points(amount):
	if not is_alive:
		return

	score += amount
	if ui:
		ui.points(score)
	if ui_reset:
		ui_reset.update_score(score)
	animated_sprite.modulate = Color(1, 1, 0)
	await get_tree().create_timer(0.5).timeout
	animated_sprite.modulate = Color(1, 1, 1)

func add_bubble():
	bubble_count += 1
	if ui:
		ui.update_bubble_count(bubble_count)

func restart_game():
	await get_tree().create_timer(0.1).timeout

func _ready():
	add_to_group("player")
	if bubble_effect:
		bubble_effect.hide()
