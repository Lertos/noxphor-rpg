extends Node

enum STATE {IN_MENU, PLAYING, CUTSCENE}

var current_state: STATE = STATE.PLAYING
var current_state_data: String = "" #A simple key that can be used to get specific data of current state
