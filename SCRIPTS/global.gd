extends Node

func _input(event):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
