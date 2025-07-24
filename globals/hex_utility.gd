extends Node

const NEIGHBOR_DIRS = [
	Vector3i(1, 0, -1), Vector3i(1, -1, 0), Vector3i(0, -1, 1),
	Vector3i(-1, 0, 1), Vector3i(-1, 1, 0), Vector3i(0, 1, -1),
]

func axial_to_cube(axial : Vector2i) -> Vector3i:
	return Vector3(axial.x, axial.y, -axial.x - axial.y)
	
func cube_to_axial(cube : Vector3i) -> Vector2i:
	return Vector2(cube.x, cube.y)

func hex_cell_distance(a: Vector2i, b: Vector2i) -> int:
	var ac := axial_to_cube(a)
	var bc := axial_to_cube(b)
	return cube_distance(ac, bc)

func get_neighbors(hex: Vector2i) -> Array[Vector2i]:
	return get_neighbors_pred(hex, func(_hex: Vector3i): return true)

func get_neighbors_pred(hex: Vector2i, pred: Callable) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for i in range(0, 6):
		var neighbor = cube_add(axial_to_cube(hex), NEIGHBOR_DIRS[i])
		if pred.call(neighbor):
			result.push_back(cube_to_axial(neighbor))
	return result

func cube_subtract(a : Vector3i, b : Vector3i) -> Vector3i:
	return Vector3i(a.x - b.x, a.y - b.y, a.z - b.z)

func cube_add(a : Vector3i, b : Vector3i) -> Vector3i:
	return Vector3i(a.x + b.x, a.y + b.y, a.z + b.z)

func cube_distance(a : Vector3i, b : Vector3i) -> float:
	var vec : Vector3i = cube_subtract(a, b)
	return (abs(vec.x) + abs(vec.y) + abs(vec.z)) / 2.0
