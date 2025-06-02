extends  CharacterBody3D

@export var speed := 12.0
@export var jump_strength := 20.0

@export var velocity_control_floor := 50.0
@export var velocity_control_air := 5.0
@export var rocket_rotation_speed := 2.5
@export var rocket_velocity := 0.10

@export var torque_control_floor := 10.0
@export var torque_contrl_air := 1.0

@onready var _balance_point: BalancePoint = $BalancePoint
@onready var _camera_anchor: CameraAnchor = $CameraAnchor

var is_anchored = false
var anchor_parent = null
var anchor_distance = 30.0
@onready var ground_ray = $RayCast3D

var points = 0.0

static func get_movement_input() -> Vector2:
	var vector := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("back") - Input.get_action_strength("forward")
	)
	if vector.length_squared() > 1:
		return vector.normalized()
	else:
		return vector
		
static func project_movement_intention(basis: Basis, up: Vector3, movement_input: Vector2) -> Vector3:
	if movement_input == Vector2.ZERO:
		return Vector3.ZERO
	
	movement_input = movement_input.normalized() * min(movement_input.length(), 1)
	
	var up_surface = -up.cross(basis.x).normalized()
	var right_surface = -up.cross(basis.y).normalized()
	
	return up_surface * movement_input.y + right_surface * movement_input.x

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()
	
		
func _physics_process(delta: float) -> void:
	
	_camera_anchor.target_origin = _balance_point.global_transform.origin
	
	if (!is_anchored and ground_ray.is_colliding() ):
		var collider = ground_ray.get_collider()
		if collider is StaticBody3D:
			anchor_to_planet(collider)
			print(collider)
	
	if is_anchored and anchor_parent:
		var dist = global_transform.origin.distance_to(anchor_parent.global_transform.origin) 
		if dist > anchor_distance:
			unanchor_to_planet()
			print('saiu')
	
	var acceleration := _balance_point.acceleration
	if acceleration == Vector3.ZERO:
		move_and_slide()
		return
	
	_camera_anchor.target_down = _balance_point.down
	set_up_direction(_balance_point.up)
	
	var movement_input := get_movement_input()
	
	var movement_intention := project_movement_intention(
		get_viewport().get_camera_3d().global_transform.basis,
		_balance_point.up,
		movement_input
	)
	
	var current_velocity_control: float
	var current_torque_control: float
	
	if is_on_floor():
		current_velocity_control = velocity_control_floor
		current_torque_control = torque_control_floor
	else:
		current_velocity_control = velocity_control_air
		current_torque_control = torque_contrl_air
		
	_process_jumping()
	
	_process_walking(movement_intention, current_torque_control * delta)
	
	velocity += acceleration * delta
	
	move_and_slide()
	if !is_on_floor():
		_rocket_mode(delta)
	else:
		_process_turning(movement_intention, current_torque_control * delta)

func _rocket_mode(delta: float):
	if not is_on_floor():
		var eixo_x  = Input.get_action_strength("forward")   - Input.get_action_strength("back")
		var eixo_z    = Input.get_action_strength("right")  - Input.get_action_strength("left")

		var delta_rot := Vector2(eixo_x, eixo_z) * rocket_rotation_speed * delta

		rotate_object_local(Vector3.RIGHT,  delta_rot.x)
		rotate_object_local(Vector3.BACK,     delta_rot.y)
	
func _process_jumping():
	var up := _balance_point.up
	var thrust_direction = transform.basis.y
	
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	var is_flying := !is_on_floor() and Input.is_action_pressed("jump")
	
	if is_jumping:
		velocity += up * jump_strength - velocity.project(up)
	elif is_flying:
		velocity += thrust_direction * rocket_velocity
		
	
func _process_walking(movement_intention: Vector3, control: float):
	var up := _balance_point.up
	
	var desired_velocity_change := movement_intention * speed - velocity
	
	desired_velocity_change -= desired_velocity_change.project(up)
	
	velocity = velocity.move_toward(
		velocity + desired_velocity_change,
		control
	)

func _process_turning(movement_intention: Vector3, control: float):
	var forward := -transform.basis.z
	var up := -_balance_point.up
	
	var look_intention_horizontal: Vector3
	if movement_intention != Vector3.ZERO:
		look_intention_horizontal = movement_intention
	else:
		look_intention_horizontal = forward - forward.project(up)
	
	var look_intention := Basis.IDENTITY.looking_at(look_intention_horizontal, -up)
	transform = Transform3D(
		transform.basis.slerp(look_intention, control).orthonormalized(),
		transform.origin
	)
	
func anchor_to_planet(planet):
	self.reparent(planet)
	is_anchored = true
	anchor_parent = planet
	
func unanchor_to_planet():
	if anchor_parent:
		self.reparent(get_tree().root)
		is_anchored = false
		anchor_parent = null

func add_points():
	points += 1
	print(points)

func get_points():
	return points
