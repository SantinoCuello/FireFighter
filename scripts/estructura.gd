extends StaticBody2D

@onready var spawner_llamas: Area2D = $SpawnerLlamas

func recieve_damage(damage):
	spawner_llamas.spawn_fire_at(self.position, damage)
