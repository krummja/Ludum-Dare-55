extends Node


func load(path: String, parent: Node, inst_name: String = "") -> Node:
	var result: Node = null
	if ResourceLoader.exists(path):
		result = ResourceLoader.load(path).instantiate()
		if result:
			if inst_name:
				result.name = inst_name
			parent.add_child(result)
	return result
