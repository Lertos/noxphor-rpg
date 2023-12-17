extends Control

func configure_initial_box(pos: Vector2, width: float, height: float):
	$Background.position = pos
	$Background.size.x = width
	$Background.size.y = height

func send_message(text: String):
	$Background/MarginContainer/VBoxContainer/Label.text = text
	self.visible = true

func close_window():
	self.visible = false
