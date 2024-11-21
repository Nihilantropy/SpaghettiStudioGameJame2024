extends Node2D

# Getter per il nodo Background
func get_background() -> Node2D:
	return $Background

# Getter per il nodo SmallMap01
func get_map() -> Node2D:
	return $SmallMap01

# Getter per il nodo PlayerNode
func get_player_node() -> Node2D:
	return $PlayerNode

# Getter per il nodo AlienNode
func get_alien_node() -> Node2D:
	return $AlienNode

# Getter per i nodi che iniziano con "EggNode"
func get_egg_nodes() -> Array:
	var egg_nodes = []
	for child in get_children():
		if child.name.begins_with("EggNode"):
			egg_nodes.append(child)
	return egg_nodes
