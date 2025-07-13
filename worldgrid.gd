##script from jess::codes on youtube, adapted from pablogila on github

extends TileMapLayer

# Exported variables for the Godot editor
@export var display_tilemap: TileMap
@export var grass_placeholder_atlas_coord: Vector2i
@export var dirt_placeholder_atlas_coord: Vector2i

# Neighbour offsets (bottom-right order)
const NEIGHBOURS: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(1, 1)
]

# Enum to represent tile types
enum TileType { Grass, Dirt }

# Dictionary mapping neighbour tile combinations to atlas coords
var neighbours_to_atlas_coord: Dictionary = {
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(2, 1),  # All corners
	[TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Grass]: Vector2i(1, 3),    # Outer bottom-right
	[TileType.Dirt, TileType.Dirt, TileType.Grass, TileType.Dirt]: Vector2i(0, 0),    # Outer bottom-left
	[TileType.Dirt, TileType.Grass, TileType.Dirt, TileType.Dirt]: Vector2i(0, 2),    # Outer top-right
	[TileType.Grass, TileType.Dirt, TileType.Dirt, TileType.Dirt]: Vector2i(3, 3),    # Outer top-left
	[TileType.Dirt, TileType.Grass, TileType.Dirt, TileType.Grass]: Vector2i(1, 0),   # Right edge
	[TileType.Grass, TileType.Dirt, TileType.Grass, TileType.Dirt]: Vector2i(3, 2),    # Left edge
	[TileType.Dirt, TileType.Dirt, TileType.Grass, TileType.Grass]: Vector2i(3, 0),  # Bottom edge

	[TileType.Grass, TileType.Grass, TileType.Dirt, TileType.Dirt]: Vector2i(1, 2),  # Top edge
	[TileType.Dirt, TileType.Grass, TileType.Grass, TileType.Grass]: Vector2i(1, 1),    # Inner bottom-right corner
	[TileType.Grass, TileType.Dirt, TileType.Grass, TileType.Grass]: Vector2i(2, 0),    # Inner bottom-left corner
	[TileType.Grass, TileType.Grass, TileType.Dirt, TileType.Grass]: Vector2i(2, 2),    # Inner top-right
	[TileType.Grass, TileType.Grass, TileType.Grass, TileType.Dirt]: Vector2i(3, 1),    # Inner top-left
	[TileType.Dirt, TileType.Grass, TileType.Grass, TileType.Dirt]: Vector2i(2, 3),   # Bottom-left top-right corners
	[TileType.Grass, TileType.Dirt, TileType.Dirt, TileType.Grass]: Vector2i(0, 1),    # Top-left down-right corners
	[TileType.Dirt, TileType.Dirt, TileType.Dirt, TileType.Dirt]: Vector2i(0, 3)    # no corners
}

# Function to update display tile and its neighbors
func set_display_tile(pos: Vector2i) -> void:
	for neighbour in NEIGHBOURS:
		var new_pos = pos + neighbour
		display_tilemap.set_cell(0, new_pos, 1, calculate_display_tile(new_pos))

# Function to calculate display tile based on world neighbours
func calculate_display_tile(coords: Vector2i) -> Vector2i:
	var bot_right: TileType = get_world_tile(coords - NEIGHBOURS[0])
	var bot_left:  TileType = get_world_tile(coords - NEIGHBOURS[1])
	var top_right: TileType = get_world_tile(coords - NEIGHBOURS[2])
	var top_left:  TileType = get_world_tile(coords - NEIGHBOURS[3])
	return neighbours_to_atlas_coord.get(
		[top_left, top_right, bot_left, bot_right],
		grass_placeholder_atlas_coord  # fallback
	)

# Function to determine tile type (grass or dirt)
func get_world_tile(coords: Vector2i) -> TileType:
	var atlas_coord: Vector2i = get_cell_atlas_coords(coords)
	if atlas_coord == grass_placeholder_atlas_coord:
		return TileType.Grass
	else:
		return TileType.Dirt
