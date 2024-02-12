extends Node

@export var player : CharacterBody3D
@export var meshRoot : Node3D
@export var cameraRoot : Node3D
@export var cameraYaw : Node3D
@export var rotationSpeed : float = 15
@export var defaultJump : JumpState
var gravity : float
var direction : Vector3
var velocity : Vector3
var speed : float
var camRotation : float = 0
var camRotationVectors : Vector3
var boostAmount : float
var boostDecayRate : float
var movementDirection

var isShiftLocked : bool
var isDodging : bool
var isIdle : bool

func _ready():
	gravity = defaultJump.jumpHeight * 60 / 17 # 17 frames to apex
	direction = Vector3(0, 0, 1)
	camRotationVectors = cameraYaw.global_transform.basis.z.normalized()

func onSetShiftLock(shiftLockState : bool):
	isShiftLocked = shiftLockState

func _physics_process(delta):
	camRotationVectors = cameraYaw.global_transform.basis.z.normalized()
	

	
	if isIdle:
		if isShiftLocked:
			velocity.x = (speed + boostAmount) * -camRotationVectors.x
			velocity.z = (speed + boostAmount) * -camRotationVectors.z
		else:
			velocity.x = (speed + boostAmount) * -direction.normalized().x
			velocity.z = (speed + boostAmount) * -direction.normalized().z
	else:
		velocity.x = (speed + boostAmount) * direction.normalized().x
		velocity.z = (speed + boostAmount) * direction.normalized().z
	
	
	
	
	if not player.is_on_floor():
			velocity.y -= gravity * delta
		
	velocity.y = clamp(velocity.y, -50, 1000)
	

	player.velocity = velocity
	player.move_and_slide()
	
	var targetRotation
	if !isShiftLocked:
		targetRotation = atan2(direction.x, direction.z) - player.rotation.y
	else:
		targetRotation = camRotation
	
	if isDodging:
		targetRotation = atan2(velocity.x, velocity.z) - player.rotation.y
		if boostAmount > 0:
			boostAmount -= boostDecayRate
		else:
			isDodging = false
			boostAmount = 0
		
	meshRoot.rotation.y = lerp_angle(meshRoot.rotation.y, targetRotation, rotationSpeed * delta)

func onSetIdleState(idleState : bool):
	isIdle = idleState

func onSetJumpState(jumpState : JumpState):
	velocity.y = jumpState.jumpHeight

func onSetMovementState(movementState : MovementState):
	speed = movementState.movementSpeed

func onSetMovementDirection(movementDirection : Vector3):
	direction = movementDirection.rotated(Vector3.UP, camRotation)
	
func onSetCamRotation(camRotation_ : float):
	camRotation = camRotation_
	
func onSetDashState(dashState : DashState):
	isDodging = true
	boostAmount = dashState.boostAmount
	boostDecayRate = dashState.boostDecayRate
	


