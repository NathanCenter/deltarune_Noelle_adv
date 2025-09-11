extends Area2D

@export var spawn_point_name: String = "ExitToLevel1"

func _on_body_entered(body):
	if body.name == "Player": # only trigger for player
		var game = get_tree().root.get_node("GameManager")
		get_tree().change_scene_to_file("res://player/node_2d.tscn")
		game.next_spawn_point = spawn_point_name
		print(game.next_spawn_point)
