extends Area2D

@export var SPEED: float = 80.0
var target_position: Vector2 = Vector2.ZERO

@export var MAX_HP: int = 30
var HP: float = 30

@onready var bar: ProgressBar = $ProgressBar


func _ready() -> void:
	bar.max_value = MAX_HP
	bar.value = MAX_HP
	bar.show_percentage = false

func _physics_process(delta: float) -> void:
	#Si no tiene posicion
	if target_position == Vector2.ZERO:
		return
	
	#Distancia hacia el objetivo
	var to_target = target_position - global_position
	var dist = to_target.length()

	# Si llego a la casa
	if dist <= 8.0:
		_on_reached_house()
		return

	# Movimiento normalizado
	var dir = to_target.normalized()
	global_position += dir * SPEED * delta

func _on_reached_house():
	print("El enemigo llegó a la casa en ", target_position)

	# Avisar al Spawner de llamas que genere fuego en esa posición
	#Busca el spawner
	var flame_spawner = get_tree().get_first_node_in_group("flame_spawner")
	#Si tiene el metodo spawn_fire_at
	if flame_spawner and flame_spawner.has_method("spawn_fire_at"):
		flame_spawner.spawn_fire_at(target_position)

	queue_free()
	
func recieve_water(cantidad: float) -> void:
	var aux = HP - cantidad
	if aux <= 0:
		HP = 0
		bar.value = HP
		queue_free()
	else:
		HP = aux
		bar.value = HP
