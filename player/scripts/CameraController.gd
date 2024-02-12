extends Node

signal setCamRotation(camRotation : float)

@onready var yawNode = $CameraYaw
@onready var pitchNode = $CameraYaw/CameraPitch
@onready var cameraSpringArm = $CameraYaw/CameraPitch/CameraSpringArm
@export var player : CharacterBody3D

var yaw : float = 0
var pitch : float = 0
var pitchMin : float = -90
var pitchMax : float = 90
var sensetivity : float = 0.3

var cameraZ = 4.077
var minimumCameraZ : float = 5
var shiftLockMaxCameraZ : float = 10
var normalMaxCameraZ : float = 50
var maxCameraZ : float #Placeholder var
var zoomAcceleration : int = 10
var minZoomSpeed : int = 1

var isShiftLocked : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	cameraSpringArm.add_excluded_object(player)

func onSetShiftLock(shiftLockState : bool):
	isShiftLocked = shiftLockState
	
func _input(event):
	if event is InputEventMouseMotion:
		if isShiftLocked or (!isShiftLocked and Input.is_action_pressed("RightClick")):
			yaw += -event.relative.x * sensetivity
			pitch += -event.relative.y * sensetivity
		
		
		
func cameraSpeedFunc(cam_z):
	
	var cameraSpeed
	if cam_z <= 18.771:
		cameraSpeed = pow(1.1, cam_z) - 1
	elif cam_z >18.771:
		cameraSpeed = 6 * log(cam_z - 12)
	print(cameraSpeed)
	
	return minZoomSpeed + cameraSpeed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pitch = clamp(pitch, pitchMin, pitchMax)
	
	
	if isShiftLocked:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		maxCameraZ = shiftLockMaxCameraZ
		cameraSpringArm.position.x = 2.4
		cameraZ = clamp(cameraZ, minimumCameraZ, maxCameraZ)
	else:
		maxCameraZ = normalMaxCameraZ
		cameraSpringArm.position.x = 0
		cameraZ = clamp(cameraZ, minimumCameraZ, maxCameraZ)
	
	yawNode.rotation_degrees.y = yaw
	pitchNode.rotation_degrees.x = pitch
	

	
	setCamRotation.emit(yawNode.rotation.y)
	
	if Input.is_action_just_released("ZoomIn"):
		if cameraZ > minimumCameraZ:
			cameraZ -= cameraSpeedFunc(cameraZ)
	elif Input.is_action_just_released("ZoomOut"):
		if cameraZ < maxCameraZ:
			cameraZ += cameraSpeedFunc(cameraZ)
	
	cameraSpringArm.spring_length = lerp(cameraSpringArm.spring_length, cameraZ, delta * zoomAcceleration)


