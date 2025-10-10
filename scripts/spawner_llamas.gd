extends Area2D

@export var fire_scene : PackedScene 
var spawn_positions : Array[Vector2] = [Vector2(265,0)]

var spawn_timer : float

var used_positions: Array[Vector2] = []

func _ready() -> void:
	add_to_group("flame_spawner")
	randomize()
	#schedule_next_spawn()
	
func _process(delta: float) -> void:
	pass
	#spawn_timer -= delta
	#if spawn_timer <= 0:
	#	spawn_fire()
	#	schedule_next_spawn()

func schedule_next_spawn():
	spawn_timer = randf_range(10,20)
	
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
		

func spawn_fire_at(pos: Vector2, damage : float):
	# Si ya está usada esa posición, no duplicamos fuego
	if pos in used_positions:
		print("⚠️ La casa en ", pos, " ya está incendiada, potenciamos fuego")
		
		# Buscar la llama que está en esa posición y potenciarla
		for child in get_children():
			if child is Area2D and child.has_method("boost_fire") and child.spawn_pos == pos:
				child.boost_fire(20) # 👈 ajustá el valor de potencia a gusto
				return
		return
	else:
		var fire_instance = fire_scene.instantiate()
		fire_instance.global_position = pos
		fire_instance.spawn_pos = pos
		fire_instance.HP = damage
		add_child(fire_instance)

		used_positions.append(pos)
		print("🔥 Casa incendiada en ", pos)

	
	
	
	
	
	
