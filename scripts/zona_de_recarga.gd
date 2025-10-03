extends Area2D

var player_inside: Node = null

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	

func _process(delta: float) -> void:
	if player_inside != null:
		player_inside.reload_water(delta)

func _on_body_entered(body):
	if body.name == "Bombero":
		player_inside = body

func _on_body_exited(body):
	if body == player_inside:
		player_inside = null
