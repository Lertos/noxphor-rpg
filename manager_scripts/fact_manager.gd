extends Node
class_name FactManager

#Operators: ==, <>, >=, <=, >, <

func does_fact_exist(fact_id: String):
	if not Data.exists(Data.TYPE.FACTS, fact_id):
		assert(false, "FactManager.gd: " + fact_id + " does not exist in Facts")
		return

#Each check uses an operator and a value to compare against
# ==FOR QUESTS
# Fact value of "0" means the quest is completed. Ex: To check if Pig Whacker is done: "quest_pig_whacker", "==", "0"
# Fact value of "-1" means it's checking that it does NOT exist yet / hasn't been started

# If the fact doesn't exist, always return false
func is_fact_true(fact_id: String, operator: String, value: float) -> bool:
	if not does_fact_exist(fact_id):
		if value == -1:
			return true
		else:
			return false
	
	var fact_value = Data.get_value(Data.TYPE.FACTS, fact_id)
	
	match operator:
		"==": if fact_value == value: return true
		"<>": if fact_value != value: return true
		">=": if fact_value >= value: return true
		"<=": if fact_value <= value: return true
		">": if fact_value > value: return true
		"<": if fact_value < value: return true
	
	return false

func set_fact(fact_id: String, new_value: float):
	if not does_fact_exist(fact_id):
		return
	
	Data.set_value(Data.TYPE.FACTS, fact_id, new_value)
	
func adjust_fact_value(fact_id: String, adjust_by_value: float):
	if not does_fact_exist(fact_id):
		return
	
	var fact = Data.get_value(Data.TYPE.FACTS, fact_id)
	
	Data.set_value(Data.TYPE.FACTS, fact_id, fact + adjust_by_value)
	
func delete_fact(fact_id: String):
	if not does_fact_exist(fact_id):
		return
	
	Data.delete_key(Data.TYPE.FACTS, fact_id)
