extends Node

func calculate_graph_type(graph : Dictionary) -> Dictionary :
	var assigned_colors : Dictionary = {}
	for node in graph.keys():
		var blocked_colors : Array[GameEnum.BaseTypes] = []
		if graph[node].is_empty():
			assigned_colors[node] = GameEnum.BaseTypes.values()[0]
			continue
		for neighbor in graph[node] :
			if assigned_colors.has(neighbor):
				blocked_colors.append(assigned_colors[neighbor])
		for type in GameEnum.BaseTypes.values() :
			if not blocked_colors.has(type) :
				assigned_colors[node] = type
				break
		if not assigned_colors.has(node):
			assigned_colors[node] = GameEnum.BaseTypes.values()[0]
			
	return assigned_colors
