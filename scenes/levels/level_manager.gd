extends Node

@export var level_scenes : Array[PackedScene]

var current_level_index = 0

func change_level(level_index):
	if level_index >= level_scenes.size():
		current_level_index = 0
	else:
		current_level_index = level_index
	get_tree().change_scene_to_packed(level_scenes[current_level_index])

func increment_level():
	change_level(current_level_index + 1)
