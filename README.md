# E12a-Animation

This is an exercise to practice creating animations in Blender and using them in Godot. This is only a simple, brief introduction (in two parts); if you want further information, I would direct you to excellent tutorials online.

As usual, Fork and Clone this repository.

The first part is the creation of an animated Blender model. For this, I would like you to follow along with the excellent CG Geek youtube tutorial, [Blender 2.8 Tutorial: Rig ANY Character for Animation in 10 Minutes](https://www.youtube.com/watch?v=SBYb1YmaOMY). He talks pretty fast, and you will need to pause frequently to follow what he is doing, but I think he does a good job of teaching the principles. The end result doesn't need to be perfect, but it should be a close approximation of his process.

I have provided the model he is animating as part of the tutorial. You should find it in this repository: LowPoly Character.blend

This process will get you to the point of having a model that is rigged for animation. To use the animation workspace in Blender, I recommend the [Complete Beginners Guide To Animation in Blender](https://www.youtube.com/watch?v=zp6kCe5Kmf4&list=PLn3ukorJv4vvHr6RMoXrZSMVqmOKlqbBR) by Grant Abbitt. Actually animating your character is beyond the scope of this exercise.

Save the resulting file.

Secondly, you will have a chance to use GDscript to enable and control the animations created in Blender. This part follows a tutorial series (using models created) by [Jayanam Games](https://www.youtube.com/watch?v=msZw59Iln74).

Sorry the repository is a bit of a mess. It was pretty messy in its original incarnation.

Load project.godot in Godot 3.2 (if you are using a previous version of Godot, you will need to extrapolate from the directions in the video). 

In the FileSystem panel. Select Run.anim. In the Inspector, make sure that Loop is selected. 

Open the Character scene. Right-click on the Character node, and Change Type. Select KinematicBody.

Right-click on the Character node and Add Child Node. Select CollisionShape. Select the new CollisionShape node. In the Inspector, CollisionShape->Shape select New CapsuleShape. Edit that CapsuleShape: set Radius=0.5 and Height=1. Go back; set Spatial->Transform->Translation.y = 1 and Rotation Degrees.x = 90.

Right-click on the Character node and Add Child Node. Select AnimationTree.

Select the new AnimationTree node, and in the Inspector edit the Anim Player to point to the AnimationPlayer that is already in the scene. Under Tree Root, select New AnimationNodeBlendTree

You should now see a new AnimationTree panel at the bottom of your screen. Move the output node over to the right so you have some room to work.

Select the Add Node… button and choose Animation. Rename the node Idle, and select the film canister icon. Select Idle-loop

Select the Add Node… button and choose Animation. Rename the node Run, and select the film canister icon. Select Run

Select the Add Node… button and choose Blend2. From the dot on the right side of the Idle animation, draw a connection to the "in" dot on Blend2. Draw a connection from the Run animation to the "blend" dot on Blend2. Draw a connection from the dot on the right side of Blend2 to Output.

As you change the numeric value in Blend2 (between 0 and 1, either typing in a new number or changing the slider), you should see the character transition between idling and running. If the character only takes a few steps, you will need to make sure you have changed the Run.anim to be looping.

Save and close the Character scene, and right-click on the Character node. Attach Script. Feel free to save it as res://Character.gd, and select the Empty Template.

Paste the following into Character.gd:
```
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
```
(replacing spaces with Tabs)

For the sake of simplicity, I have created a box CollisionShape in a StaticBody for the player to stand on. If you choose, you can go through and create Trimesh Static Bodies for each of the meshes in the terrain.

Run the program, and make sure that the character is animated as it moves. When you are satisfied, commit and push your repository and turn in the URL of your repository on Canvas.