extends Node

#This singleton is used to reference common nodes using a single variable/method.
#The paths will always be the same, or if it changes, you only need to change it here.

@onready var Root = get_tree().get_root().get_node("root")

@onready var Scenes = SceneManager.new()
@onready var Player = PlayerManager.new()
@onready var Command = CommandManager.new()
@onready var Dialogues = DialogueManager.new()
@onready var Facts = FactManager.new()

var camera
