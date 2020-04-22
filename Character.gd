extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var camera

const SPEED = 6
const ACCELERATION = 3
const DE_ACCELERATION = 5

func _ready():
	camera = get_node("../Camera").get_global_transform()


func _physics_process(delta):
	var dir = Vector3()
	if(Input.is_action_pressed("Forward")):
		dir += -camera.basis[2]
	if(Input.is_action_pressed("Back")):
		dir += camera.basis[2]
	if(Input.is_action_pressed("Left")):
		dir += -camera.basis[0]
	if(Input.is_action_pressed("Right")):
		dir += camera.basis[0]
	dir.y = 0
	dir = dir.normalized()
	velocity.y += delta * gravity
	var hv = velocity
	hv.y = 0
	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	
	hv = hv.linear_interpolate(new_pos, accel * delta)
	velocity.x = hv.x
	velocity.z = hv.z
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	var speed = hv.length() / SPEED
	$AnimationTree.set("parameters/Idle_Run/blend_amount",speed)