extends Area2D

@export var fire_scene: PackedScene


func _ready() -> void:
	add_to_group("flame_spawner")


func spawn_fire_at(pos: Vector2, damage):
	
	for child in get_children():
		if child.has_method("boost_fire") and child.spawn_pos == pos:
			child.boost_fire(damage) 
			print("🔥 Potenciando fuego en ", pos)
			return
	var fire_instance = fire_scene.instantiate()
	fire_instance.global_position = pos
	fire_instance.spawn_pos = pos
	
	add_child(fire_instance)
	
	print("🔥 Nueva llama creada en ", pos)
