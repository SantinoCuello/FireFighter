extends CharacterBody2D

@export var speed = 100
var target_position: Vector2 = Vector2.ZERO

@export var MAX_HP: int = 30
var HP: float = 30

@onready var bar: ProgressBar = $ProgressBar

var DAMAGE = 50

@onready var area: Area2D = $Area2D


func _ready() -> void:
	bar.max_value = MAX_HP
	bar.value = MAX_HP
	bar.show_percentage = false
	area.connect("body_entered", Callable(self, "_on_area_entered"))
	
func _process(delta: float) -> void:
	get_parent().set_progress(get_parent().get_progress() + speed*delta)
	if get_parent().get_progress_ratio() == 1:
		queue_free()
	
func _on_area_entered(body):
	if body.has_method("recieve_damage"):
		body.recieve_damage(DAMAGE)
		queue_free() # opcional: enemigo muere tras chocar
	
func recieve_water(water: float) -> void:
	var aux = HP - water
	if aux <= 0:
		HP = 0
		bar.value = HP
		queue_free()
	else:
		HP = aux
		bar.value = HP
