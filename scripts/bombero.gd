extends CharacterBody2D

@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D

const SPEED = 100
const MAX_RANGE = 100

func _ready() -> void:
	ray.enabled = true
	line.visible = false

func _physics_process(delta):
	player_movement()
	water_shoot()
	
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
	if Input.is_action_pressed("shoot"):
		line.visible = true
		update_water_to_mouse()
		
		if ray.is_colliding():
			var objective = ray.get_collider()
			if objective != null && objective.has_method("recieve_water"):
				objective.recieve_water(20 * get_process_delta_time())
	else:
		line.visible = false
		
func update_water_to_mouse():
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	
	ray.target_position = dir * MAX_RANGE
	
	line.set_point_position(0, Vector2.ZERO) 
	line.set_point_position(1, dir*MAX_RANGE)
