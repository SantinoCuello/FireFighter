extends Area2D

@export var enemy_scene: PackedScene
@export var spawn_timer_range: Vector2 = Vector2(1,5)

var spawn_positions: Array[Vector2] = [
	Vector2(-274,-25)
]

@onready var flame_spawner: Area2D = $"../SpawnerLlamas"

var spawn_timer: float

func _ready() -> void:
	randomize()
	schedule_next_spawn()
	
func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		schedule_next_spawn()

func schedule_next_spawn():
	spawn_timer = randf_range(spawn_timer_range.x, spawn_timer_range.y)

func spawn_enemy():
	# Casas disponibles = las que no están incendiadas
	var available_houses = flame_spawner.spawn_positions.filter(
		func(p): return not p in flame_spawner.used_positions
	)
	
	if enemy_scene == null or available_houses.is_empty():
		print("No hay casas disponibles para spawnear enemigos")
		return

	# Lugar donde aparece el enemigo (puede ser una posición fija o aleatoria)
	var spawn_pos = spawn_positions[randi() % spawn_positions.size()]
	
	# Casa destino = la más lejana al spawn
	var farthest_house = available_houses[0]
	var max_dist = spawn_pos.distance_to(farthest_house)
	for house in available_houses:
		var dist = spawn_pos.distance_to(house)
		if dist > max_dist:
			max_dist = dist
			farthest_house = house

	# Instanciar enemigo y asignarle destino
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_pos
	enemy.target_position = farthest_house   # 👈 se le pasa la casa ya elegida
	add_child(enemy)

	print("Enemigo spawn en", spawn_pos, "y va hacia", farthest_house)
