extends Area2D

@export var fire_scene : PackedScene #
var spawn_positions : Array[Vector2] = [Vector2(169,79),Vector2(169,-70),Vector2(-108,74),Vector2(-108,-71)]

var spawn_timer : float

var used_positions: Array[Vector2] = []

func _ready() -> void:
	randomize()
	schedule_next_spawn()
	
func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_fire()
		schedule_next_spawn()

func schedule_next_spawn():
	spawn_timer = randf_range(1,5)
	
func spawn_fire():
	#Calcula posiciones disponibles viendo las que no esta
	var available_positions = spawn_positions.filter(func(p): return not p in used_positions) 
	
	if (fire_scene == null) or available_positions.is_empty():
		print("Ya esta todo incendiado")
		return
	
	var pos = available_positions[randi() % available_positions.size()]
	
	available_positions.erase(pos)
	used_positions.append(pos)
	
	
	var fire_instance = fire_scene.instantiate()
	
	fire_instance.spawn_pos = pos
	fire_instance.global_position = pos
	
	add_child(fire_instance)
	
func release_position(pos: Vector2):
		used_positions.erase(pos)
		print("🚒 Casa apagada en ", pos, " vuelve a estar disponible.")
	
	
	
	
	
