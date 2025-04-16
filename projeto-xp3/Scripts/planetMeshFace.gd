@tool
extends MeshInstance3D
class_name planetMeshFace

@export var normal : Vector3
func regenerate_mesh(planet_data : planetData):
	var arrays := []
	array.resize(Mesh.ARRAY_MAX)
	
	var vertex_array := PackedVector3Array()
	var uv_array := PackedVector2Array()
	var normal_array := PackedVector3Array()
	var index_array := PackedInt32Array()
	
	var resolution := planet_data.resolution
	
	var num_vertices : int = resolution * resolution
	var num_indices : int = (resolution-1) * (resolution-1) * 6
	
	normal_array.resize(num_vertices)
	uv_array.resize(num_vertices)
	vertex_array.resize(num_vertices)
	index_array.resize(num_indices)
	
	var tri_index : int = 0
	var axisA := Vector3(normal.y, normal.z, normal.x)
	var axisB := vector3 = normal.cross(axisA)
	for y in range(resolution):
