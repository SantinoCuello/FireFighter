extends StaticBody2D

var Bullet = preload("res://towers/bullet.tscn")
var bulletDamage = 20
var pathName
var currentTargets = []
var curr

func _process(delta: float) -> void:
	if is_instance_valid(curr):
		self.look_at(curr.global_position)

func _on_tower_body_entered(body: Node2D) -> void:
	if "Enemigo1" in body.name:
		var tempArray = []
		currentTargets = get_node("Tower").get_overlapping_bodies()
		
		for i in currentTargets:
			if "Enemigo" in i.name:
				tempArray.append(i)	
				
		var currentTarget = null
		
		for i in tempArray:
			if currentTarget == null:
				currentTarget = i.get_node("../")
			else:
				if i.get_parent().get_progress() > currentTarget.get_progress():
					currentTarget = i.get_node("../")
					
		curr = currentTarget	
		pathName = currentTarget.get_parent().name
		
		var tempBullet = Bullet.instantiate()
		tempBullet.pathName = pathName
		tempBullet.bulletDamage = bulletDamage
		get_node("BulletContainer").add_child(tempBullet)
		tempBullet.global_position = $Aim.global_position
	
func _on_tower_body_exited(body: Node2D) -> void:
	currentTargets = get_node("Tower").get_overlapping_bodies()
