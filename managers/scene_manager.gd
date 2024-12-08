extends Node


func get_element(group_name: StringName) -> Node:
	return self.get_tree().get_first_node_in_group(group_name)


func get_elements(group_name: StringName) -> Array[Node]:
	return self.get_tree().get_nodes_in_group(group_name)


func get_closest_element(group_name: StringName, reference: Variant) -> Node:
	var elements: Array[Node] = get_elements(group_name)
	var closest_element: Node = null
	var closest_distance: float = INF

	for element in elements:
		var distance: float = reference.position.distance_to(element.position)
		if  distance < closest_distance:
			closest_distance = distance
			closest_element = element

	return closest_element
