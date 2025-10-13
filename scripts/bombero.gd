extends CharacterBody2D

#VIDA Y ESTADISTICAS
@onready var hp_bar: ProgressBar = $HPBar

var HP : int = 100
var MAX_HP: int = 100
const SPEED = 100
#Muerte
@onready var respawn_label: Label = $RespawnLabel
var is_dead: bool = false
var respawn_time: float = 4.0
var respawn_timer: float = 0.0


#AGUA
@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D
@onready var water_bar: ProgressBar = $WaterBar

const MAX_RANGE = 100
const MAX_WATER = 100

var water: float = MAX_WATER
var water_consumption_rate: float = 20.0


func _ready() -> void:
	ray.enabled = true
	line.visible = false
	water_bar.value = MAX_WATER
	hp_bar.value = MAX_HP

func _physics_process(delta):
	if is_dead:
		handle_respawn(delta)
		return  # no puede moverse ni disparar
		
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
	
func recieve_damage(damage):
	if is_dead:
		return
	var aux = HP - damage
	if aux <= 0:
		HP = 0
		hp_bar.value = HP
		die()
	else:
		HP = aux
		hp_bar.value = HP
	
func die():
	is_dead = true
	respawn_timer = respawn_time
	respawn_label.visible = true
	line.visible = false  # deja de disparar
	print("Bombero fuera de servicio por 3 segundos")
	
func handle_respawn(delta):
	respawn_timer -= delta
	respawn_label.text = "Reactivando en: " + str(round(respawn_timer)) + "..."
	
	if respawn_timer <= 0:
		respawn_label.visible = false
		is_dead = false
		HP = MAX_HP
		hp_bar.value = HP
		print("Bombero listo para volver a trabajar 🚒")




	
func water_shoot():
	if Input.is_action_pressed("shoot") and water > 0:
		line.visible = true
		update_water_to_mouse()
		
		#Gastar agua
		water -= water_consumption_rate * get_process_delta_time()
		if water <= 0:
			water = 0
			print("Ya no hay agua")
		
		water_bar.value = water
		
		if ray.is_colliding():
			var objective = ray.get_collider()
			print(objective)
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
		water_bar.value = water
