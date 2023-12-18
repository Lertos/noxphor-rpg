extends Node

enum STATE {IN_MENU, PLAYING, CUTSCENE}

var current_state: STATE = STATE.PLAYING
var current_state_data: String = "" #A simple key that can be used to get specific data of current state

func change_state(new_state: STATE, state_string: String = ""):
	current_state = new_state
	current_state_data = state_string

func is_state(check_state: STATE):
	return check_state == current_state
	
func is_data(state_data: String):
	return state_data == current_state_data
