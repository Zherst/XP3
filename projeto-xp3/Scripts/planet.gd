@tool
extends Node

@export var planet_data: PlanetData:
	set(val):
		if planet_data:  # Disconnect the old resource signal if it exists
			planet_data.changed.disconnect(_on_resource_changed)
		planet_data = val
		if planet_data:  # Connect the new resource signal
			planet_data.changed.connect(_on_resource_changed)
	get:
		return planet_data
	
func _ready():
	add_to_group("planet")
	for child in get_children():
		if child is MeshInstance3D:
			_update_collision(child)

func _on_resource_changed():
	planet_data.min_height = 99999.0
	planet_data.max_height = 0.0
	
	for child in get_children():
		var face = child as PlanetMeshFace
		if face:
			face.regenerate_mesh(planet_data)
		_update_collision(child)

func _update_collision(mesh_instance: MeshInstance3D):

	for grandchild in mesh_instance.get_children():
		if grandchild is StaticBody3D or CollisionShape3D:
			grandchild.queue_free()
	
	mesh_instance.create_convex_collision(true,true)
	var coli = mesh_instance.get_children()
	if coli is StaticBody3D:
		coli.add_to_group("planet")
