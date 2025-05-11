extends Node3D

@export var G: float = 9.8
@export var center_node: Node3D
@export var center_mass: float = 1.0
@export var orbit_anomaly: float = 0.0
@export var orbit_points: int = 128

@onready var fall_off = $PlanetMesh/GravityWell/FallOffModel
var semi_major_axis: float
var semi_minor_axis: float
var angle: float = 0.0
var velocity: float = 0.0

var orbit_mesh_instance: MeshInstance3D
var orbit_material := StandardMaterial3D.new()

func _ready():
	fall_off.max_acceleration = G
	if center_node:
		var offset = global_transform.origin - center_node.global_transform.origin
		semi_major_axis = offset.length()
		semi_minor_axis = semi_major_axis + orbit_anomaly
		draw_orbit_path()


func _process(delta):
	update_position(delta)

func update_position(delta):
	if not center_node:
		return
	else:
		var distance = calculate_distance_to_center(angle)
		velocity = sqrt(G * center_mass * (2.0 / distance - 1.0 / semi_major_axis))
		angle += velocity * delta / distance

		var orbit_pos = calculate_ellipse_pos(angle)
		global_transform.origin = center_node.global_transform.origin + orbit_pos

func calculate_ellipse_pos(angle) -> Vector3:
	var x = semi_major_axis * cos(angle)
	var z = semi_minor_axis * sin(angle)

	return Vector3(x, 0.0, z)

func calculate_distance_to_center(angle):
	var x = semi_major_axis * cos(angle)
	var z = semi_minor_axis * sin(angle)
	return sqrt(x * x + z * z)

func draw_orbit_path():
	var mesh := ImmediateMesh.new()
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)

	for i in orbit_points:
		var a = float(i) / orbit_points * TAU
		var pos = calculate_ellipse_pos(a)
		mesh.surface_add_vertex(pos)

	# Fechar a elipse
	mesh.surface_add_vertex(calculate_ellipse_pos(0.0))
	mesh.surface_end()

	# Criar o visual da linha de órbita
	orbit_mesh_instance = MeshInstance3D.new()
	orbit_mesh_instance.mesh = mesh

	orbit_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	orbit_material.albedo_color = Color.WHITE
	orbit_mesh_instance.material_override = orbit_material

	center_node.add_child(orbit_mesh_instance)
	orbit_mesh_instance.owner = center_node.get_owner()
