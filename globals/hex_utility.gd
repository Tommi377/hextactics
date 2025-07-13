extends Node

func axial_to_cube(axial : Vector2) -> Vector3:
	return Vector3(axial.x, axial.y, -axial.x - axial.y)
	
func cube_to_axial(cube : Vector3) -> Vector2:
	return Vector2(cube.x, cube.y)

func hex_cell_distance(a: Vector2i, b: Vector2i) -> int:
	var ac = axial_to_cube(a)
	var bc = axial_to_cube(b)
	return axial_distance(ac, bc)

func axial_subtract(a : Vector3, b : Vector3):
	return Vector3(a.x - b.x, a.y - b.y, a.z - b.z)

func axial_add(a : Vector3, b : Vector3):
	return Vector3(a.x + b.x, a.y + b.y, a.z + b.z)

func axial_distance(a : Vector3, b : Vector3):
	var vec : Vector3 = axial_subtract(a, b)
	return (abs(vec.x) + abs(vec.y) + abs(vec.z)) / 2.0
