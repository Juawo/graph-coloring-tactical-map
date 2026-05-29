extends Node

func calculate_graph_type(graph : Dictionary) -> Dictionary :
	var assigned_colors : Dictionary = {}
	for node in graph.keys():
		var blocked_colors : Array[GameEnum.BaseTypes] = []
		for neighbor in graph[node] :
			if assigned_colors.has(neighbor):
				blocked_colors.append(neighbor.base_type)
		for type in GameEnum.BaseTypes.values() :
			if not blocked_colors.has(type) :
				assigned_colors[node] = type
				break
	return assigned_colors
