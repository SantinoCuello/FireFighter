extends CharacterBody2D

@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D
@onready var bar: ProgressBar = $ProgressBar

const SPEED = 100
const MAX_RANGE = 100
const MAX_WATER = 100

var water: float = MAX_WATER
var water_consumption_rate: float = 20.0

func _ready() -> void:
	ray.enabled = true
	line.visible = false
	bar.value = 100

func _physics_process(delta):
	player_movement()
	water_shoot()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision:
			var collider = collision.get_collider()
			if collider.name == "Bomba":
				reload_water(delta)
	
func player_movement():
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	
	if dir != Vector2.ZERO:
		dir = dir.normalized()
		velocity = dir * SPEED
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
func water_shoot():
	if Input.is_action_pressed("shoot") and water > 0:
		line.visible = true
		update_water_to_mouse()
		
		#Gastar agua
		water -= water_consumption_rate * get_process_delta_time()
		if water <= 0:
			water = 0
			print("Ya no hay agua")
		
		bar.value = water
		
		if ray.is_colliding():
			var objective = ray.get_collider()
			if objective != null && objective.has_method("recieve_water"):
				objective.recieve_water(40 * get_process_delta_time())
	else:
		line.visible = false
		
		
func update_water_to_mouse():
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	
	ray.target_position = dir * MAX_RANGE
	
	line.set_point_position(0, Vector2.ZERO) 
	line.set_point_position(1, dir*MAX_RANGE)

func reload_water(delta):
	water += MAX_WATER   # velocidad de recarga
	if water > MAX_WATER:
		water = MAX_WATER
		bar.value = water
