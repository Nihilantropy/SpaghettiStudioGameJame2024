extends MarginContainer

@export var player_node: PackedScene
@onready var player = null  # Initialize player after the scene is loaded
@export var zoom = 1.5

@onready var grid = $MarginContainer/GridNode2D
@onready var player_marker = $MarginContainer/GridNode2D/PlayerMarker
@onready var alien_marker = $MarginContainer/GridNode2D/AlienMarker
@onready var egg_marker = $MarginContainer/GridNode2D/EggMarker

@onready var icons = {"alien": alien_marker, "egg": egg_marker}

var grid_scale = 0
var markers = {}

func _ready():
	# Assign player instance from PackedScene
	var player_instance = player_node.instantiate()
	if not player_instance:
		push_error("Player node instance could not be created!")
		return
	
	add_child(player_instance)  # Add player to the scene
	
	# Use find_node or direct path to get the CharacterBody2D node
	player = player_instance.get_node("CharacterBody2D")  # Adjust this path as needed
	if not player:
		push_error("CharacterBody2D node could not be found in player scene!")
		return
	
	player_marker.position = grid.size / 2
	grid_scale = grid.size / (get_viewport_rect().size * zoom)
	
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		if item.minimap_icon in icons:
			var new_marker = icons[item.minimap_icon].duplicate()
			grid.add_child(new_marker)
			new_marker.show()
			markers[item] = new_marker
		else:
			print("Unknown icon type for object: %s" % item)

#func _on_resized() -> void:
#	player_marker.position = grid.size / 2
#	grid_scale = grid.size / (get_viewport_rect().size * zoom)

func _process(_delta):
	if !player:
		return

	player_marker.rotation = player.rotation + PI / 2

	for item in markers.keys():
		var obj_pos = (item.position - player.position) * grid_scale + grid.size / 2
		markers[item].position = obj_pos

		obj_pos.x = clamp(obj_pos.x, 0, grid.size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.size.y)

		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].hide()
		else:
			markers[item].show()
