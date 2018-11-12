extends Node2D

export(int) var inputs = 2
export(String) var target_flag

var input_dict = {}

var output = false

func _ready():
	hide()
	for i in range(inputs):
		input_dict[i] = false

func set_input(num, state):
	input_dict[num] = state
	if all_true() and not output:
		controller.flag[target_flag] = 1
		output = true
		
func all_true():
	return input_dict.values().count(true) == inputs