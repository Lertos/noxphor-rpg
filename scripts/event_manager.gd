extends Node
class_name EventManager

var player = PlayerManager.new()

func _init():
	print("here")
	player.test("hey", 1)
