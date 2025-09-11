extends Node2D

func _ready():
	var game = get_tree().root.get_node("GameManager")
	if game.next_spawn_point != "":
		var spawn = $SpawnPoints.get_node_or_null(game.next_spawn_point)
		if spawn:
			$Player.global_position = spawn.global_position
