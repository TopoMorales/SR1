extends CharacterBody2D

@export var speed = 300.0  # Rychlost lodi
@export var rotation_speed = 2.0  # Rychlost otáčení lodi
@export var friction = 0.25  # Koeficient tření (čím vyšší, tím rychleji zpomaluje)
@export var rotate_velocity_90 = false  # Přepínač pro otočení vektoru o 90°
@export var thrust_swap_time: float = 0.1
var thrust_timer: float = 0.0
var current_thrust_sprite = 1
var is_moving = 0
var is_moving_reverse = 0

func _ready():
	$thrust1.visible = false
	$thrust2.visible = false
	$reverse1.visible = false
	$reverse2.visible = false

func _process(delta):
	# Získání aktuální velocity a výpočet pohybu
	var ship_velocity = velocity

	if Input.is_action_pressed("ui_up"):
		# Loď se pohybuje dopředu ve směru své rotace
		ship_velocity = Vector2(speed, 0).rotated(rotation)
		ship_velocity = ship_velocity.rotated(-PI / 2)  # Otočení vektoru o 90° proti směru hodinových ručiček
		is_moving = true
	elif Input.is_action_pressed("ui_down"):
			ship_velocity = ship_velocity.lerp(Vector2.ZERO, 0.05)
			is_moving_reverse = true
	else:
		# Použití tření, pokud loď není ve fázi pohybu
		ship_velocity = ship_velocity.lerp(Vector2.ZERO, friction * delta)
		is_moving = false
		is_moving_reverse = false
	if is_moving and velocity.length() > 0.1:
		# Zobraz trysky a střídání spritů, pokud se loď pohybuje
		_show_thrust(delta)
		$reverse1.visible = false
		$reverse2.visible = false
	elif is_moving_reverse and velocity.length() > 0.5:
		
		$thrust1.visible = false
		$thrust2.visible = false
		$reverse1.visible = true
		$reverse2.visible = true
	else:
		# Skryj trysky, pokud loď není v pohybu
		$thrust1.visible = false
		$thrust2.visible = false
		$reverse1.visible = false
		$reverse2.visible = false
		
	# Otočení lodi na základě vstupu
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	elif Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta

	# Nastavení rychlosti pomocí vestavěné vlastnosti velocity
	velocity = ship_velocity

	# Aplikuj pohyb lodi
	move_and_slide()

func _show_thrust(delta):
	# Aktualizuj časovač střídání spritů
	thrust_timer += delta
	if thrust_timer >= thrust_swap_time:
		# Střídání spritů
		if current_thrust_sprite == 1:
			$thrust1.visible = false
			$thrust2.visible = true
			current_thrust_sprite = 2
		else:
			$thrust1.visible = true
			$thrust2.visible = false
			current_thrust_sprite = 1
		
		
