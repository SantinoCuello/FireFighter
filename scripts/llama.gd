extends Area2D

@export var MAX_HP: int = 100
var HP: float = 0
var EXPANSION_SPEED: float = 5.0

@onready var bar: ProgressBar = $ProgressBar

var spawn_pos : Vector2

func _ready() -> void:
	bar.max_value = MAX_HP
	bar.value = HP
	bar.show_percentage = false

func _process(delta: float) -> void:
	HP += EXPANSION_SPEED * delta
	if HP >= MAX_HP:
		HP = MAX_HP
		fire()

	bar.value = HP

func recieve_water(cantidad: float) -> void:
	var aux = HP - cantidad
	if aux <= 0:
		HP = 0
		bar.value = HP
		queue_free()
	else:
		HP = aux
		bar.value = HP

func boost_fire(cantidad: float) -> void:
	HP += cantidad
	if HP > MAX_HP:
		HP = MAX_HP
	bar.value = HP
	print("🔥 La llama en ", spawn_pos, " fue potenciada. HP = ", HP)


func fire():
	print("La casa se prende fuego!!")
