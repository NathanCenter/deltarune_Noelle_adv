extends Area2D
@export var spawn_point_name: String = "ExitToLevel2"
func _on_body_entered(body):
	if body.name == "Player": # only trigger for player
		var game = get_tree().root.get_node("GameManager")
		get_tree().change_scene_to_file("res://level2/level2-outside the house.tscn")
		game.next_spawn_point = spawn_point_name
		print(game.next_spawn_point)
