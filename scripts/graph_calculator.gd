extends Node

# Implementação do Algoritmo Guloso (Greedy Heuristic) para Coloração de Vértices
func calculate_graph_type(graph : Dictionary) -> Dictionary :
	var assigned_colors : Dictionary = {} # Guarda a atribuição de cor/tipo de cada nó
	
	# Percorre todos os vértices do grafo dinâmico
	for node in graph.keys():
		var blocked_colors : Array[GameEnum.BaseTypes] = []
		
		# Vértices isolados (grau 0) recebem por padrão a primeira cor disponível
		if graph[node].is_empty():
			assigned_colors[node] = GameEnum.BaseTypes.values()[0]
			continue
			
		# Mapeia as cores já utilizadas pelos vizinhos adjacentes
		for neighbor in graph[node] :
			if assigned_colors.has(neighbor):
				blocked_colors.append(assigned_colors[neighbor])
				
		# Atribuição Gulosa: seleciona a primeira cor da lista que NÃO está bloqueada
		for type in GameEnum.BaseTypes.values() :
			if not blocked_colors.has(type) :
				assigned_colors[node] = type
				break # Encontrou uma cor válida sem conflito, interrompe a busca local
				
		# Fallback de segurança: caso todas as cores estejam bloqueadas
		if not assigned_colors.has(node):
			assigned_colors[node] = GameEnum.BaseTypes.values()[0]
			
	return assigned_colors # Retorna o dicionário final com o mapeamento (Vértice -> Cor)
